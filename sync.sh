#!/usr/bin/env bash

set -eo pipefail

touch ~/.env.zsh
home-manager switch -v
rm -rf ~/.config/nvim/lua/
