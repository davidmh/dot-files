#!/usr/bin/env bash

set -eo pipefail

touch ~/.env.zsh

home-manager switch -v

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
