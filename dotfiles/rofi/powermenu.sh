#!/usr/bin/env zsh

lock="󰌾  Lock"
logout="󰍃  Logout"
suspend="󰤄  Suspend"
reboot="󰜎  Reboot"
shutdown="󰐥  Power Off"

chosen=$(printf "%s\n" "$lock" "$logout" "$suspend" "$reboot" "$shutdown" | rofi -dmenu -i -p "Power Menu")

case "$chosen" in
    "$lock")
        swaylock --screenshots --clock --indicator --indicator-radius 100 --indicator-thickness 7 --effect-blur 7x5 --effect-vignette 0.5:0.5 --ring-color bb9af7 --key-hl-color 7dcfff --line-color 00000000 --inside-color 1a1b2688 --separator-color 00000000 --grace 2 --fade-in 0.2
        ;;
    "$logout")
        swaymsg exit
        ;;
    "$suspend")
        systemctl suspend
        ;;
    "$reboot")
        systemctl reboot
        ;;
    "$shutdown")
        systemctl poweroff
        ;;
esac
