{ pkgs, config, inputs, ... }:

{
  home.sessionVariables = {
    EDITOR = "nvim";
    TIG_EDITOR = "nvim";
    DIRENV_LOG_FORMAT = "";
    OVERCOMMIT_COLOR = 0;
  };

  home.packages = with pkgs; [
    asciinema
    asciinema-agg
    android-tools
    bat
    coreutils
    clojure
    fd
    fx
    gcc
    go
    htop
    imagemagick
    jdk
    jq
    lazygit
    leiningen
    lsd
    nodejs_22
    (yarn.override { nodejs = nodejs_22; })
    pass
    pnpm
    selene
    silver-searcher
    ripgrep
    tig
    ueberzug
    unstable.aerospace
    unstable.ast-grep
    unstable.bun
    unstable.deno
    unstable.devenv
    unstable.cargo
    unstable.gh
    unstable.git-absorb
    unstable.gnupg
    unstable.jankyborders
    unstable.lldb_19
    unstable.lua
    unstable.lua51Packages.luarocks-nix
    unstable.neovim
    unstable.nixpkgs-fmt
    unstable.nerd-fonts.hasklug
    unstable.tree-sitter
    unstable.shellcheck
    wezterm

    # Remix
    colima
    docker
    docker-compose
    postgresql_16
    redis
  ];

  programs.home-manager.enable = true;

  programs.direnv.enable = true;

  programs.starship.enable = true;

  programs.zsh = {
    enable = true;
    autocd = true;
    initExtraBeforeCompInit = ''
      if [ -f ~/.config/extra.zsh ]; then
        source ~/.config/extra.zsh
      fi
    '';
    history.ignoreSpace = true;
    antidote = {
      enable = true;
      plugins = [
        "zsh-users/zsh-completions kind:fpath"
        "zsh-users/zsh-autosuggestions kind:defer"
        "zdharma-continuum/fast-syntax-highlighting kind:defer"

        # OMZ
        "getantidote/use-omz" # handle OMZ dependencies
        "ohmyzsh/ohmyzsh path:lib" # load OMZ's library
        "ohmyzsh/ohmyzsh path:plugins/git"
        "ohmyzsh/ohmyzsh path:plugins/dirhistory"
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
      push.autoSetupRemote = true;
      commit.gpgsign = true;
      user.signingkey = "86C60D761EB5F758";
      delta.side-by-side = true;
      delta.line-numbers = false;
    };

    diff-so-fancy.enable = true;
    lfs.enable = true;
  };

  programs.jujutsu = {
    enable = true;
    package = pkgs.unstable.jujutsu;
    settings = {
      user = {
        name = "David Mejorado";
        email = "david.mejorado@gmail.com";
      };
    };
  };

  programs.emacs = {
    enable = true;
    package = pkgs.unstable.emacs;
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

  programs.zellij = {
    enable = true;
  };

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 28800;
    enableSshSupport = true;
    pinentryPackage = pkgs.pinentry_mac;
  };
}
