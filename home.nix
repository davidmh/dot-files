{ config, pkgs, lib, ... }:

{
  home.stateVersion = "23.05";

  home.sessionVariables = {
    EDITOR = "nvim";
    TIG_EDITOR = "nvim";
    DIRENV_LOG_FORMAT = "";
  };

  home.packages = with pkgs; [
    cargo
    clojure
    evcxr
    fd
    (nerdfonts.override { fonts = [ "Hasklig" ]; })
    fx
    gh
    htop
    jq
    lazygit
    leiningen
    lsd
    lua51Packages.luarocks
    neovim
    pass
    silver-searcher
    sketchybar
    teamocil
    tig
    yabai
  ];

  programs.home-manager.enable = true;

  programs.direnv.enable = true;

  programs.zsh = {
    enable = true;
    enableCompletion = false;
    envExtra = builtins.readFile ~/.env.zsh;
    autocd = true;
    history.ignoreSpace = true;
    zplug = {
      enable = true;
      plugins = [
        { name = "plugins/git"; tags = ["from:oh-my-zsh"]; }
        { name = "plugins/dirhistory"; tags = ["from:oh-my-zsh"]; }
        { name = "plugins/colorize"; tags = ["from:oh-my-zsh"]; }
        { name = "plugins/chruby"; tags = ["from:oh-my-zsh"]; }
        { name = "plugins/colored-man-pages"; tags = ["from:oh-my-zsh"]; }
        { name = "zsh-users/zsh-syntax-highlighting"; }
        { name = "zsh-users/zsh-autosuggestions"; }
        { name = "zsh-users/zsh-completions"; }
        { name = "spwhitt/nix-zsh-completions"; }
        { name = "subnixr/minimal"; tags = ["as:theme"]; }
      ];
    };
    shellAliases = {
      vim = "nvim";
      ll = "lsd -l";
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

    extraConfig = {
      init.defaultBranch = "main";
      rebase.autosquash = true;
    };

    diff-so-fancy.enable = true;
    lfs.enable = true;
  };

  programs.wezterm = {
    enable = true;
  };

  programs.tmux = {
    enable = true;
    keyMode = "vi";
    extraConfig = ''set -ag terminal-overrides ",xterm*:Tc"'';
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
    source = config.lib.file.mkOutOfStoreSymlink ./nvim;
    recursive = true;
  };

  xdg.configFile."wezterm/wezterm.lua" = {
    source = config.lib.file.mkOutOfStoreSymlink ./wezterm.lua;
  };

  xdg.configFile.sketchybar = {
    source = config.lib.file.mkOutOfStoreSymlink ./sketchybar;
    recursive = true;
  };
  xdg.configFile.yabai = {
    source = config.lib.file.mkOutOfStoreSymlink ./yabai;
    recursive = true;
  };
  xdg.configFile.skhd = {
    source = config.lib.file.mkOutOfStoreSymlink ./skhd;
    recursive = true;
  };
}
