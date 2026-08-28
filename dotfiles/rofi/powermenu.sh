#!/usr/bin/env fish

set lock "󰌾  Lock"
set logout "󰍃  Logout"
set suspend "󰤄  Suspend"
set reboot "󰜎  Reboot"
set shutdown "󰐥  Power Off"

set chosen (string join "\n" $lock $logout $suspend $reboot $shutdown | rofi -dmenu -i -p "Power Menu")

switch $chosen
    case $lock
        swaylock
    case $logout
        swaymsg exit
    case $suspend
        systemctl suspend
    case $reboot
        systemctl reboot
    case $shutdown
        systemctl poweroff
end
EOF
