{ config, pkgs, ... }:
{
  programs.noctalia-shell = {
    enable = true;
  };

  home.packages = with pkgs; [
    # screenshot utilities
    grim # selects regions
    satty # annotates images
    slurp # takes the screenshot
  ];

  xdg.configFile."noctalia/settings.json".source = config.lib.file.mkOutOfStoreSymlink "${config.custom.dotfiles}/config/noctalia-settings.json";
}
