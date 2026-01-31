{ config, lib, ... }:
{
  programs.neovim = {
    enable = true;
    plugins = lib.mkForce [ ];
    withRuby = false;
    withPython3 = false;
    withNodeJs = false;
  };

  xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.custom.dotfiles}/nvim";
}
