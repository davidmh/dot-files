{ config, ... }:
{
  programs.starship.enable = true;

  xdg.configFile."starship.toml".source = config.lib.file.mkOutOfStoreSymlink "${config.custom.dotfiles}/config/starship.toml";
}
