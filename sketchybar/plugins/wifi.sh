#!/usr/bin/env bash

source "$HOME/.config/sketchybar/colors.sh"

CURRENT_WIFI="$(/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I)"
SSID="$(echo "$CURRENT_WIFI" | grep -o "SSID: .*" | sed 's/^SSID: //')"

sketchybar --set "Control Center,WiFi" label="${SSID}"
