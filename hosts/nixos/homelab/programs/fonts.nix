{ pkgs, ... }:
{
  fonts.fontconfig.enable = true;

  fonts.fontconfig.defaultFonts = {
    monospace = [ "Hasklug Nerd Font" ];
    sansSerif = [ "Hasklug Nerd Font" "Source Han Sans" ];
    serif = [ "Hasklug Nerd Font" "Source Han Serif" ];
    emoji = [ "Noto Color Emoji" ];
  };

  home.packages = with pkgs; [
    font-awesome
    nerd-fonts.hasklug
    source-han-sans
    noto-fonts-color-emoji
  ];
}
