import json
import os
import subprocess
import sys
import threading
import time

try:
    import evdev
    from evdev import ecodes
except ImportError:
    sys.exit(1)

APP_ID = "org.vinegarhq.Sober"
JUMP_KEY = ecodes.KEY_SPACE
JUMPS_PER_TICK = 3
JUMP_GAP = 0.06
MOUSE_DEVICE = os.environ.get("MOUSE_DEVICE", "")
SCROLL_DOWN_SIGN = "negative"

def find_mouse_device():
    if MOUSE_DEVICE:
        return evdev.InputDevice(MOUSE_DEVICE)

    candidates = []
    for path in evdev.list_devices():
        try:
            dev = evdev.InputDevice(path)
        except (PermissionError, OSError):
            continue
        caps = dev.capabilities()
        if ecodes.REL_WHEEL in caps.get(ecodes.EV_REL, []):
            candidates.append(dev)

    if not candidates:
        return None

    for dev in candidates:
        if ecodes.BTN_LEFT in dev.capabilities().get(ecodes.EV_KEY, []):
            return dev
    return candidates[0]

def make_virtual_keyboard():
    return evdev.UInput({ecodes.EV_KEY: [JUMP_KEY]}, name="sober-scroll-jump-kbd")

def jump_burst(ui):
    for _ in range(JUMPS_PER_TICK):
        ui.write(ecodes.EV_KEY, JUMP_KEY, 1)
        ui.syn()
        time.sleep(0.02)
        ui.write(ecodes.EV_KEY, JUMP_KEY, 0)
        ui.syn()
        time.sleep(JUMP_GAP)

def is_scroll_down(value):
    if SCROLL_DOWN_SIGN == "negative":
        return value < 0
    return value > 0

def watch_for_close(app_proc):
    try:
        sway = subprocess.Popen(
            ["swaymsg", "-t", "subscribe", "-m", '["window"]'],
            stdout=subprocess.PIPE,
            text=True,
        )
    except FileNotFoundError:
        sway = None

    while True:
        if app_proc.poll() is not None:
            os._exit(0)

        if sway is not None:
            line = sway.stdout.readline()
            if not line:
                continue
            try:
                event = json.loads(line)
            except json.JSONDecodeError:
                continue
            if (
                event.get("change") == "close"
                and event.get("container", {}).get("app_id") == APP_ID
            ):
                os._exit(0)
        else:
            time.sleep(0.5)

def main():
    mouse = find_mouse_device()
    if mouse is None:
        sys.exit(1)

    try:
        ui = make_virtual_keyboard()
    except PermissionError:
        sys.exit(1)

    app_proc = subprocess.Popen(["flatpak", "run", APP_ID])

    watcher = threading.Thread(target=watch_for_close, args=(app_proc,), daemon=True)
    watcher.start()

    try:
        for event in mouse.read_loop():
            if event.type == ecodes.EV_REL and event.code == ecodes.REL_WHEEL:
                if is_scroll_down(event.value):
                    threading.Thread(target=jump_burst, args=(ui,), daemon=True).start()
    except KeyboardInterrupt:
        pass
    finally:
        ui.close()

if __name__ == "__main__":
    main()
