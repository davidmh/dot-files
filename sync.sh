#!/usr/bin/env bash

set -eo pipefail

rm -rf ~/.config/nvim 2> /dev/null
rm -rf ~/.config/wezterm 2> /dev/null
rm -rf ~/.config/starship.toml 2> /dev/null

mkdir -p ~/.config/wezterm

ln -s ~/.config/home-manager/nvim ~/.config/nvim
ln -s ~/.config/home-manager/wezterm.lua ~/.config/wezterm/wezterm.lua 2> /dev/null
ln -s ~/.config/home-manager/starship.toml ~/.config/starship.toml 2> /dev/null

if ! command -v home-manager &> /dev/null; then
  nix run home-manager/release-23.05 -- init --switch
else
  home-manager switch
fi

if [[  "$(uname)" == "Darwin" ]]; then
  HOME_APPS="$HOME"/Applications
  NIX_APPS="$HOME"/.nix-profile/Applications

  # remove broken links
  for f in "$HOME_APPS"/*; do
      if [ -L "$f" ] && [ ! -e "$f" ]; then
          rm "$f"
      fi
  done

  # link new ones
  for f in "$NIX_APPS"/*; do
      app_name="$(basename "$f")"
      echo "$HOME_APPS/$app_name"
      if [ ! -e "$HOME_APPS/$app_name" ]; then
          echo ln -s "$f" "$HOME_APPS"/
          ln -s "$f" "$HOME_APPS"/
      fi
  done
fi
