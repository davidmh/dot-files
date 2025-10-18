#!/usr/bin/env bash

set -eo pipefail

rm -rf ~/.config/nvim 2> /dev/null
rm -rf ~/.config/kitty 2> /dev/null
rm -rf ~/.config/ghostty 2> /dev/null
rm -rf ~/.config/starship.toml 2> /dev/null
rm -rf ~/.config/aerospace 2> /dev/null

mkdir -p ~/.config/aerospace

ln -s ~/.config/home-manager/nvim ~/.config/nvim
ln -s ~/.config/home-manager/ghostty ~/.config/ghostty
ln -s ~/.config/home-manager/aerospace.toml ~/.config/aerospace/aerospace.toml 2> /dev/null
ln -s ~/.config/home-manager/starship.toml ~/.config/starship.toml 2> /dev/null

if ! command -v home-manager &> /dev/null; then
  nix run home-manager -- init --switch
else
  home-manager switch
fi

if [[  "$(uname)" == "Darwin" ]]; then
  USER_APPS=/Applications
  NIX_APPS="$HOME"/.nix-profile/Applications

  # remove broken links
  for f in "$USER_APPS"/*; do
      if [ -L "$f" ] && [ ! -e "$f" ]; then
          rm "$f"
      fi
  done

  # link new ones
  for f in "$NIX_APPS"/*; do
      app_name="$(basename "$f")"
      echo "$USER_APPS/$app_name"
      if [ ! -e "$USER_APPS/$app_name" ]; then
          echo ln -s "$f" "$USER_APPS"/
          ln -s "$f" "$USER_APPS"/
      fi
  done
fi
