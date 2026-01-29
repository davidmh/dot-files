#!/usr/bin/env bash

set -eo pipefail

if ! command -v home-manager &> /dev/null; then
  nix run home-manager -- init --switch
else
  home-manager switch
fi
