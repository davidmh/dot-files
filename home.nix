{ pkgs, lib, inputs, ... }:

{
  home.sessionVariables = {
    EDITOR = "nvim";
    TIG_EDITOR = "nvim";
    MANPAGER = "nvim +Man!";
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
    stylua
    silver-searcher
    ripgrep
    tig
    unstable.aerospace
    unstable.ast-grep
    unstable.bun
    unstable.deno
    unstable.cargo
    unstable.gh
    unstable.gh-dash
    unstable.git-absorb
    unstable.gnupg
    unstable.jankyborders
    unstable.lldb_19
    unstable.lua
    unstable.lua51Packages.luarocks-nix
    unstable.nixpkgs-fmt
    unstable.nerd-fonts.hasklug
    unstable.tree-sitter
    unstable.shellcheck
    unstable.sqlfluff
    unstable.plantuml

    # LSP
    unstable.air-formatter
    unstable.bash-language-server
    unstable.clojure-lsp
    unstable.fennel-ls
    unstable.gopls
    unstable.harper
    unstable.jdt-language-server
    unstable.lua-language-server
    unstable.nil
    unstable.python313Packages.jedi-language-server
    unstable.ruff
    unstable.rust-analyzer
    unstable.solargraph
    unstable.sqls
    unstable.terraform-ls
    unstable.tflint
    unstable.typos-lsp
    unstable.vscode-langservers-extracted
    unstable.yaml-language-server

    # Remix
    colima
    docker
    docker-compose
    postgresql_16
    redis
  ];

  programs.home-manager.enable = true;

  programs.direnv = {
    enable = true;
    config = {
      global = {
        hide_env_diff = true;
      };
    };
  };

  programs.starship.enable = true;

  programs.zoxide = {
    enable = true;
    options = [ "--cmd" "cd" ];
  };

  programs.zsh = {
    enable = true;
    autocd = true;
    initContent = lib.mkOrder 550 ''
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

  programs.neovim = {
    enable = true;
    package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
    withRuby = false;
    withPython3 = false;
    withNodeJs = false;
  };

  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "David Mejorado";
        email = "david.mejorado@gmail.com";
      };
      alias = {
        current-branch = "rev-parse --abbrev-ref HEAD";
        default-branch = "config init.defaultBranch";
        fresh = "!git fetch origin $(git default-branch):$(git default-branch) && git switch $(git default-branch)";
        pushc = "!git push origin $(git current-branch)";
        pullc = "!git pull origin $(git current-branch)";
        amend-date = ''!LC_ALL=C GIT_COMMITTER_DATE="$(date)" git commit -n --amend --no-edit --date "$(date)"'';
      };
      init.defaultBranch = "main";
      rebase.autosquash = true;
      fetch.writeCommitGraph = true;
      push.autoSetupRemote = true;
      commit.gpgsign = true;
      user.signingkey = "86C60D761EB5F758";
      delta.side-by-side = true;
      delta.line-numbers = false;
    };

    lfs.enable = true;
  };

  programs.diff-so-fancy.enable = true;

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

  programs.ghostty = {
    enable = true;
    package = pkgs.ghostty-bin;
  };

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 28800;
    enableSshSupport = true;
    pinentry.package = pkgs.pinentry_mac;
  };
}
