-- ~/.config/hypr/hyprland.lua
local hl = require("hyprland")

-- 1. MONITORS
hl.config.monitors = {
    { name = "", resolution = "preferred", position = "auto", scale = 1 }
}

-- 2. AUTOSTART
hl.exec_once({
    "waybar",
    "hyprpaper",
    "dunst"
})

-- 3. ENVIRONMENT VARIABLES
hl.env({
    XCURSOR_SIZE = "24",
    HYPRCURSOR_SIZE = "24",
    QT_QPA_PLATFORM = "wayland;xcb",
    GDK_BACKEND = "wayland,x11"
})

-- 4. GENERAL & LOOK
hl.config.general = {
    gaps_in = 5,
    gaps_out = 10,
    border_size = 2,
    col_active_border = "rgba(7aa2f7ee) rgba(bb9af7ee) 45deg",
    col_inactive_border = "rgba(414868aa)",
    layout = "dwindle"
}

hl.config.decoration = {
    rounding = 8,
    blur = {
        enabled = true,
        size = 4,
        passes = 2
    },
    shadow = {
        enabled = true,
        range = 6,
        render_power = 3,
        color = "rgba(1a1a1aee)"
    }
}

hl.config.animations = {
    enabled = true,
    bezier = {
        myBezier = { 0.05, 0.9, 0.1, 1.05 }
    },
    animation = {
        { "windows", 1, 7, "myBezier" },
        { "windowsOut", 1, 7, "default", "popin 80%" },
        { "border", 1, 10, "default" },
        { "fade", 1, 7, "default" },
        { "workspaces", 1, 6, "default" }
    }
}

-- 5. KEYBINDINGS
local mod = "SUPER"

-- Core Dispatchers
hl.bind(mod, "RETURN", "exec", "kitty")
hl.bind(mod, "Q", "killactive")
hl.bind(mod, "M", "exit")
hl.bind(mod, "V", "togglefloating")
hl.bind(mod, "R", "exec", "rofi -show drun")

-- Focus Movement (Vim keys)
hl.bind(mod, "h", "movefocus", "l")
hl.bind(mod, "l", "movefocus", "r")
hl.bind(mod, "k", "movefocus", "u")
hl.bind(mod, "j", "movefocus", "d")

-- Workspaces 1-4
for i = 1, 4 do
    local key = tostring(i)
    hl.bind(mod, key, "workspace", key)
    hl.bind(mod .. "_SHIFT", key, "movetoworkspace", key)
end

-- Mouse Bindings
hl.bindm(mod, "mouse:272", "movewindow")
hl.bindm(mod, "mouse:273", "resizewindow")
