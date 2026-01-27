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
