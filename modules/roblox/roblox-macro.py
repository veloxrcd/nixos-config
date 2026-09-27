#!/usr/bin/env python3
"""
roblox (aka sober-scroll-jump.py)

Launches Sober (Roblox, via flatpak) and turns "scroll wheel down" into
rapid jump presses while it's running, by talking to the kernel input
layer directly:

  - reads raw scroll events off the mouse's /dev/input/eventN
  - injects synthetic KEY_SPACE presses through a virtual keyboard it
    creates via /dev/uinput

No ydotool / ydotoold involved - this IS the same kernel mechanism
ydotool uses under the hood (uinput), just without the daemon/socket
in between.

Requirements (NixOS): see sober-macro-nixos-config.nix
  - hardware.uinput.enable = true;  (creates /dev/uinput + loads module)
  - python3 with the `evdev` package
  - "input" group membership (for /dev/input/eventN and /dev/uinput)

If jumping happens on scroll UP instead of DOWN, flip SCROLL_DOWN_SIGN
below. If it ever picks the wrong mouse, override MOUSE_DEVICE.
"""

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
    sys.exit(
        "python3 'evdev' module not found. On NixOS, use a python3 "
        "with the evdev package (see sober-macro-nixos-config.nix)."
    )

# ---- config ---------------------------------------------------------------

APP_ID = "org.vinegarhq.Sober"
JUMP_KEY = ecodes.KEY_SPACE
JUMPS_PER_TICK = 3          # "1 little movement" = this many jumps
JUMP_GAP = 0.06              # seconds between each jump press in a burst
MOUSE_DEVICE = os.environ.get("MOUSE_DEVICE", "/dev/input/event2")   # your YiChip mouse
SCROLL_DOWN_SIGN = "negative"        # "negative" or "positive" - which
                                       # REL_WHEEL value means scroll DOWN

# ---- helpers ---------------------------------------------------------------


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
    """Runs in a background thread. Exits the whole process the moment
    Sober's window closes, or if the flatpak process itself dies."""
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
            print("[sober-macro] Sober process exited, ending macro")
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
                print("[sober-macro] Sober window closed, ending macro")
                os._exit(0)
        else:
            time.sleep(0.5)


# ---- main -------------------------------------------------------------


def main():
    mouse = find_mouse_device()
    if mouse is None:
        sys.exit(
            "[sober-macro] couldn't auto-detect a mouse device.\n"
            "  Run: python3 -c \"import evdev; "
            "[print(d.path, d.name) for d in evdev.list_devices()]\"\n"
            "  then set MOUSE_DEVICE=/dev/input/eventN before running this script."
        )
    print(f"[sober-macro] using mouse device: {mouse.path} ({mouse.name})")

    try:
        ui = make_virtual_keyboard()
    except PermissionError:
        sys.exit(
            "[sober-macro] permission denied opening /dev/uinput.\n"
            "  Make sure hardware.uinput.enable = true; is set (NixOS) "
            "and that you have access to /dev/uinput."
        )

    print(f"[sober-macro] launching {APP_ID}...")
    app_proc = subprocess.Popen(["flatpak", "run", APP_ID])

    watcher = threading.Thread(target=watch_for_close, args=(app_proc,), daemon=True)
    watcher.start()

    print("[sober-macro] scroll-down -> jump active")
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

