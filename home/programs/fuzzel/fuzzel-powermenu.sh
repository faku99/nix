#!/bin/bash

SELECTION="$(printf "1 - Lock\n2 - Log out\n3 - Shutdown\n4 - Reboot\n5 - Reboot to UEFI" | fuzzel --dmenu -l 5 -p "Power Menu: ")"

case $SELECTION in
    *"Lock")
        hyprlock
        ;;
    *"Log out")
        hyprctl dispatch exit
        ;;
    *"Shutdown")
        systemctl poweroff;;
    *"Reboot")
        systemctl reboot
        ;;
    *"Reboot to UEFI")
        systemctl reboot --firmware-setup
        ;;
esac
