{ pkgs, inputs, ... }:

{
  home.sessionVariables = {
    EDITOR = "nvim";
    TIG_EDITOR = "nvim";
    DIRENV_LOG_FORMAT = "";
    OVERCOMMIT_COLOR = 0;
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (pkgs: true);
    };
    overlays = [
      (final: prev: {
        unstable = import inputs.unstable {
          system = final.system;
          config.allowUnfree = true;
        };
      })
      inputs.neovim-nightly-overlay.overlay
    ];
  };

  home.packages = with pkgs; [
    bat
    cargo
    clojure
    evcxr
    fd
    fx
    go
    htop
    imagemagick
    jdk
    jq
    lazygit
    leiningen
    lsd
    lua51Packages.luarocks
    # moreutils
    nodejs_18
    yarn
    pass
    silver-searcher
    ripgrep
    tig
    ueberzug
    # unstable.cbc
    unstable.fortune-kind
    unstable.gh
    unstable.git-absorb
    unstable.wezterm
    (unstable.nerdfonts.override { fonts = [ "Hasklig" ]; })
  ];

  programs.home-manager.enable = true;

  programs.neovim = {
    enable = true;
    package = pkgs.neovim-nightly;
    extraLuaPackages = ps: [ ps.magick ];
  };

  programs.direnv.enable = true;

  programs.starship.enable = true;

  programs.zsh = {
    enable = true;
    completionInit = ''
      autoload -Uz compinit
      for dump in ~/.zcompdump(N.mh+24); do
        compinit
      done
      compinit -C

      autoload -U select-word-style
      select-word-style bash
    '';
    autocd = true;
    history.ignoreSpace = true;
    zplug = {
      enable = true;
      plugins = [
        { name = "plugins/git"; tags = [ "from:oh-my-zsh" ]; }
        { name = "plugins/dirhistory"; tags = [ "from:oh-my-zsh" ]; }
        { name = "plugins/chruby"; tags = [ "from:oh-my-zsh" ]; }
        # { name = "mattberther/zsh-pyenv"; }
        { name = "zsh-users/zsh-syntax-highlighting"; }
        { name = "zsh-users/zsh-autosuggestions"; }
        { name = "zsh-users/zsh-completions"; }
        { name = "jeffreytse/zsh-vi-mode"; }
      ];
    };
    shellAliases = {
      v = "nvim";
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
      fetch.writeCommitGraph = true;
    };

    diff-so-fancy.enable = true;
    lfs.enable = true;
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
}
