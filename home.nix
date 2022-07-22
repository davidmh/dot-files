{ config, pkgs, ... }:

{
  home.username = "chaac";
  home.homeDirectory = "/home/chaac";

  home.stateVersion = "22.05";

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.packages = [
    pkgs.cargo
    pkgs.diff-so-fancy
    pkgs.fx
    pkgs.gcc
    pkgs.gh
    pkgs.jq
    pkgs.neovim
    pkgs.nodejs
    pkgs.pass
    pkgs.silver-searcher
    pkgs.teamocil
    pkgs.tdesktop
    pkgs.tig
    pkgs.xclip
    pkgs.yarn
  ];

  programs.home-manager.enable = true;

  programs.zsh = {
    enable = true;
    enableCompletion = false;
    envExtra = builtins.readFile ~/.env.zsh;
    autocd = true;
    history.ignoreSpace = true;
    initExtra = ''
      source "${pkgs.antigen}/share/antigen/antigen.zsh"
      antigen use oh-my-zsh
      antigen bundle git
      antigen bundle dirhistory
      antigen bundle colorize
      antigen bundle colored-man-pages
      antigen bundle zsh-users/zsh-syntax-highlighting
      antigen bundle zsh-users/zsh-autosuggestions
      antigen bundle zsh-users/zsh-completions
      antigen bundle spwhitt/nix-zsh-completions.git
      antigen apply
      antigen theme nanotech
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
      current-branch = "commit --amend --no-edit -n";
      fresh = "!git switch master && git pull origin master && git fetch";
      pushc = "!git push origin $(git current-branch)";
      pullc = "!git pull origin $(git current-branch)";
      amend-date = ''!LC_ALL=C GIT_COMMITTER_DATE="$(date)" git commit -n --amend --no-edit --date "$(date)"'';
    };

    diff-so-fancy.enable = true;
    lfs.enable = true;
  };

  programs.tmux = {
    enable = true;
    plugins = [
      pkgs.tmuxPlugins.nord
      pkgs.tmuxPlugins.vim-tmux-navigator
      pkgs.tmuxPlugins.yank
    ];
  };

  services.gpg-agent.enable = true;

  xdg.configFile.nvim = {
    source = ./nvim;
    recursive = true;
  };
}
