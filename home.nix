{ config, pkgs, lib, ... }:

let
  optionals = lib.optionals;
  os = builtins.currentSystem;
  isLinux = os == "x86_64-linux";
  isDarwin = !isLinux;
  userName = builtins.getEnv "USER";
  homeDirectory = builtins.getEnv "HOME";
in
{
  home.username = userName;
  home.homeDirectory = homeDirectory;

  home.stateVersion = "23.05";

  home.sessionVariables = {
    EDITOR = "nvim";
    TIG_EDITOR = "nvim";
  };

  home.packages = with pkgs; [
    deno
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
    lua51Packages.luarocks
    neovim
    pass
    silver-searcher
    teamocil
    tig
  ] ++ (optionals isLinux [ tdesktop xclip ]);

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

  imports = [] ++ (optionals isLinux [ ./linux.nix ]);
}
