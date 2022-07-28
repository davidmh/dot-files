#!/usr/bin/env bash

set -eo pipefail

touch ~/.env.zsh
home-manager switch
rm -rf ~/.config/nvim/lua/
