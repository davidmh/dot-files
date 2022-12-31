#!/usr/bin/env bash

WEATHER_JSON=$(curl -s "https://wttr.in/?format=j1")

if [[ -z "$WEATHER_JSON" ]]; then
  return
fi

TEMPERATURE=$(echo "$WEATHER_JSON" | jq -r '.current_condition[0].temp_C')
WEATHER_DESCRIPTION=$(echo "$WEATHER_JSON" | jq -r '.current_condition[0].weatherDesc[0].value' | sed 's/\(.\{25\}\).*/\1.../')
NEAREST_AREA=$(echo "$WEATHER_JSON" | jq -r '.nearest_area[0].areaName[0].value')
REGION=$(echo "$WEATHER_JSON" | jq -r '.nearest_area[0].region[0].value')

sketchybar --set "$NAME" label="$NEAREST_AREA - ${TEMPERATURE}ᶜ $WEATHER_DESCRIPTION"

case "$SENDER" in
  "mouse.clicked") 
    # The google widget is easier to read
    open "https://google.com/search?q=weather+$NEAREST_AREA+$REGION"
    ;;
esac
