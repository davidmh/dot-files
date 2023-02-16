#!/usr/bin/env bash

CURRENT_LAYOUT=$(yabai -m query --spaces --space | jq -r '.type')
DISPLAYS=$(yabai -m query --displays)
DISPLAY_COUNT=$(echo "$DISPLAYS" | jq length)
DISPLAY_WIDTH=$(echo "$DISPLAYS" | jq '.[0].frame.w')

if [[ $DISPLAY_COUNT -eq 1 ]]; then
  if [[ $DISPLAY_WIDTH -gt 1512 ]]; then
    TARGET_LAYOUT="bsp"
  else
    TARGET_LAYOUT="stack"
  fi

  if [[ "$CURRENT_LAYOUT" != "$TARGET_LAYOUT" ]]; then
    yabai -m space 1 --layout "$TARGET_LAYOUT"
  fi
fi
