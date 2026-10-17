#!/usr/bin/env bash

# Options with Nerd Font icons
shutdown="󰐥"
reboot="󰜉"
lock="󰌾"
logout="󰍃"

# Pass options to rofi with horizontal menu layout
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
