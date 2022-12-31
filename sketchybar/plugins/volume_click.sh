#!/usr/bin/env bash

toggle_mute() {
  sketchybar --set "$NAME" popup.drawing=off

  MUTED=$(osascript -e 'output muted of (get volume settings)')

  if [ "$MUTED" = "false" ]; then
    osascript -e 'set volume output muted true'
  else
    osascript -e 'set volume output muted false'
  fi
  exit 0
}

open_sound_preferences() {
  open -b com.apple.systempreferences /System/Library/PreferencePanes/Sound.prefPane
}

if [ "$BUTTON" = "right" ]; then
  open_sound_preferences
else
  toggle_mute
fi
