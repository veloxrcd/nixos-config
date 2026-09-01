#!/usr/bin/env fish

set lock "󰌾  Lock"
set logout "󰍃  Logout"
set suspend "󰤄  Suspend"
set reboot "󰜎  Reboot"
set shutdown "󰐥  Power Off"

set chosen (printf "%s\n" "$lock" "$logout" "$suspend" "$reboot" "$shutdown" | rofi -dmenu -i -p "Power Menu")

switch $chosen
    case $lock
        swaylock --screenshots --clock --indicator --indicator-radius 100 --indicator-thickness 7 --effect-blur 7x5 --effect-vignette 0.5:0.5 --ring-color bb9af7 --key-hl-color 7dcfff --line-color 00000000 --inside-color 1a1b2688 --separator-color 00000000 --grace 2 --fade-in 0.2
    case $logout
        swaymsg exit
    case $suspend
        systemctl suspend
    case $reboot
        systemctl reboot
    case $shutdown
        systemctl poweroff
end
