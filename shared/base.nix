{ ... }:
{
  home.sessionVariables = {
    EDITOR = "nvim";
    TIG_EDITOR = "nvim";
    MANPAGER = "nvim +Man!";
  };

  programs.home-manager.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.11";
}
