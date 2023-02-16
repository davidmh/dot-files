#!/usr/bin/env bash

# https://github.com/kirtan-shah/nowplaying-cli
DETAILS=$(command "$HOME/.config/sketchybar/bin/nowplaying-cli" get title artist | awk -v d=" — " '{s=(NR==1?s:s d)$0}END{print s}')

echo sketchybar --set $NAME icon="" icon.padding_right=5 label="${DETAILS}"
