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
  "Docker Desktop")
    ICON=
    ;;
  "FaceTime" | "zoom.us")
    ICON=辶
    ;;
  "Finder")
    ICON=
    ;;
  "Grammarly Desktop")
    ICON=ﯩ
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
  "Preview")
    ICON=
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
  "Tuple")
    ICON=
    ;;
  "VLC")
    ICON=嗢
    ;;
  *)
    ICON=ﬓ
    ;;
esac

sketchybar --set $NAME icon=$ICON icon.padding_right=5 label="$INFO"
