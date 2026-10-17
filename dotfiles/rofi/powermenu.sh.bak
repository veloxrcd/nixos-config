#!/usr/bin/env bash

# Options
shutdown="󰐥 Shutdown"
reboot="󰜉 Reboot"
lock="󰌾 Lock"
logout="󰍃 Logout"

# Get choice from rofi
options="$shutdown\n$reboot\n$lock\n$logout"
chosen=$(echo -e "$options" | rofi -dmenu -i -theme ~/nixos-config/dotfiles/rofi/powermenu.rasi -p "Power")

case $chosen in
    $shutdown)
        systemctl poweroff ;;
    $reboot)
        systemctl reboot ;;
    $lock)
        loginctl lock-session ;;
    $logout)
        pkill -u $USER ;;
esac
