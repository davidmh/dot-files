{ config, pkgs, lib, ... }:

let
  optionals = lib.optionals;
  os = builtins.currentSystem;
  isLinux = os == "x86_64-linux";
  isDarwin = os == "x86_64-darwin";
  userName = builtins.getEnv "USER";
  homeDirectory = builtins.getEnv "HOME";
in
{
  home.username = userName;
  home.homeDirectory = homeDirectory;

  home.stateVersion = "22.05";

  home.sessionVariables = {
    EDITOR = "nvim";
    TIG_EDITOR = "nvim";
  };

  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz;
    }))
  ];

  home.packages = [
    pkgs.cargo
    pkgs.diff-so-fancy
    pkgs.fx
    pkgs.gcc
    pkgs.gh
    pkgs.jq
    pkgs.neovim
    pkgs.nodejs-14_x
    pkgs.pass
    pkgs.silver-searcher
    pkgs.teamocil
    pkgs.tig
    pkgs.yarn
  ] ++ (optionals isLinux [ pkgs.tdesktop pkgs.xclip ]);

  programs.home-manager.enable = true;

  programs.zsh = {
    enable = true;
    enableCompletion = false;
    envExtra = builtins.readFile ~/.env.zsh;
    autocd = true;
    history.ignoreSpace = true;
    oh-my-zsh = {
      enable = true;
      plugins = ["git" "dirhistory" "colorize" "colored-man-pages"];
      theme = "nanotech";
    };
    initExtra = ''
      source "${pkgs.antigen}/share/antigen/antigen.zsh"
      antigen bundle zsh-users/zsh-syntax-highlighting
      antigen bundle zsh-users/zsh-autosuggestions
      antigen bundle zsh-users/zsh-completions
      antigen bundle spwhitt/nix-zsh-completions.git
      antigen apply
      '';
    shellAliases = {
      vim = "nvim";
    };
  };

  programs.git = {
    enable = true;
    userName = "David Mejorado";
    userEmail = "david.mejorado@gmail.com";

    aliases = {
      current-branch = "rev-parse --abbrev-ref HEAD";
      default-branch = "!git rev-parse --abbrev-ref origin/HEAD | awk -F/ '{print $2}'";
      fresh = "!git switch $(git default-branch) && git pull origin $(git default-branch) && git fetch";
      pushc = "!git push origin $(git current-branch)";
      pullc = "!git pull origin $(git current-branch)";
      amend-date = ''!LC_ALL=C GIT_COMMITTER_DATE="$(date)" git commit -n --amend --no-edit --date "$(date)"'';
    };

    diff-so-fancy.enable = true;
    lfs.enable = true;
  };

  programs.tmux = {
    enable = true;
    keyMode = "vi";
    plugins = [
      pkgs.tmuxPlugins.sensible
      pkgs.tmuxPlugins.vim-tmux-navigator
      pkgs.tmuxPlugins.yank
      {
        plugin = pkgs.tmuxPlugins.dracula;
        extraConfig = ''
          set -g @dracula-show-left-icon session
          set -g @dracula-show-flags true
          set -g @dracula-military-time true
          set -g @dracula-plugins "time"
        '';
      }
    ];
  };

  xdg.configFile.nvim = {
    source = ./nvim;
    recursive = true;
  };

  imports = []
    ++ (optionals isDarwin [ ./darwin.nix ])
    ++ (optionals isLinux [ ./linux.nix ]);
}
