{ pkgs, ... }:
with pkgs; [
  # git
  lazygit
  gh
  gh-dash
  tig

  # misc utilities
  (yarn.override {
    nodejs = nodejs_22;
  })
  ast-grep
  bat
  fd
  fx
  jq
  lsd
  nodejs_22
  pass
  ripgrep
  silver-searcher
  unzip

  # linters/formatters
  selene
  stylua
  gnupg
  lua
  lua51Packages.luarocks-nix
  nixpkgs-fmt
  gcc # for tree-sitter
  tree-sitter
  shellcheck

  # LSP
  air-formatter
  bash-language-server
  clojure-lsp
  fennel-ls
  gopls
  harper
  lua-language-server
  nil
  python313Packages.jedi-language-server
  ruff
  solargraph
  typos-lsp
  vscode-langservers-extracted
  yaml-language-server
]
