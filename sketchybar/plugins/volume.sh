#!/usr/bin/env bash

MUTED=$(osascript -e 'output muted of (get volume settings)')
LABEL_DRAWING="on"

if [[ ${MUTED} = "true" ]]; then
  ICON="婢"
  LABEL_DRAWING="off"
elif [[ ${INFO} -gt 49 ]]; then
  ICON="墳"
elif [[ ${INFO} -gt 30 ]]; then
  ICON="奔"
else
  ICON="奄"
fi

sketchybar --set $NAME icon=$ICON label="$INFO%" label.drawing=$LABEL_DRAWING
