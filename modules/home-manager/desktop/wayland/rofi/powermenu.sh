#!/usr/bin/env bash

THEME="powermenu"
DIRECTORY="${PWD}" # TODO: Change

# Options
SHUTDOWN=''
REBOOT=''
LOCK=''
LOGOUT=''

rofi_cmd() {
    rofi -dmenu -theme ${DIRECTORY}/${THEME}.rasi
}

run_rofi() {
    echo -e "${LOCK}\n${LOGOUT}\n${REBOOT}\n${SHUTDOWN}" | rofi_cmd
}

CHOSEN="$(run_rofi)"
case ${CHOSEN} in
    $SHUTDOWN)
        systemctl poweroff
        ;;
    $REBOOT)
        systemctl reboot
        ;;
    $LOCK)
        echo "LOCK"
        ;;
    $LOGOUT)
        echo "LOGOUT!"
        ;;
    *)
        ;;
esac
