#!/usr/bin/env bash

case $INFO in
  "Activity Monitor")
    ICON=
    ;;
  "WezTerm" | "iTerm2" | "Terminal")
    ICON=
    ;;
  "Calendar")
    ICON=
    ;;
  "Discord")
    ICON=ﭮ
    ;;
  "FaceTime" | "zoom.us")
    ICON=辶
    ;;
  "Finder")
    ICON=
    ;;
  "Google Chrome")
    ICON=
    ;;
  "Firefox Developer Edition")
    ICON=
    ;;
  "Messages")
    ICON=
    ;;
  "Script Editor")
    ICON=亮
    ;;
  "Slack")
    ICON=
    ;;
  "System Preferences")
    ICON=
    ;;
  "Telegram")
    ICON=切
    ;;
  *)
    ICON=﯂
    ;;
esac

sketchybar --set $NAME icon=$ICON icon.padding_right=5 label="$INFO"
