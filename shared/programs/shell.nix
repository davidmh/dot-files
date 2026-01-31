{ lib, ... }:
{
  programs.atuin.enable = true;

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
}
