#!/usr/bin/env bash

source "$HOME/.config/sketchybar/colors.sh"

PERCENTAGE=$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)
CHARGING=$(pmset -g batt | grep 'AC Power')

if [ $PERCENTAGE = "" ]; then
  exit 0
fi

case ${PERCENTAGE} in
   100) COLOR=0xff${NORD14:1} ;;
   9[0-9]) COLOR=0xff${NORD14:1} ;;
   8[0-9]) COLOR=0xff${NORD14:1} ;;
   7[0-9]) COLOR=0xff${NORD14:1} ;;
   6[0-9]) COLOR=0xff${NORD14:1} ;;
   5[0-9]) COLOR=0xff${NORD14:1} ;;
   4[0-9]) COLOR=0xff${NORD14:1} ;;
   3[0-9]) COLOR=0xff${NORD13:1} ;;
   2[0-9]) COLOR=0xff${NORD13:1} ;;
   1[0-9]) COLOR=0xff${NORD11:1} ;;
   *) COLOR=0xff${NORD11:1}
esac

[ $CHARGING != "" ] && COLOR=0xff${NORD14:1}

sketchybar --set "Control Center,Battery" alias.color=$COLOR label="  ${PERCENTAGE}%   "
