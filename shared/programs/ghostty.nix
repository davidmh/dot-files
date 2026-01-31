{ pkgs, lib, ... }:
{
  programs.ghostty = with pkgs; {
    enable = true;
    package = (
      if stdenv.isDarwin then
        ghostty-bin
      else
        ghostty
    );
    settings = {
      cursor-style = "block";
      font-family = "Hasklug Nerd Font";
      font-family-italic = "Dank Mono";
      font-family-bold = "Dank Mono";
      font-family-bold-italic = "Dank Mono";
      font-size = if stdenv.isDarwin then 15 else 10;
      font-thicken = true;
      mouse-hide-while-typing = true;
      quit-after-last-window-closed = true;
      theme = "Catppuccin Mocha";
      window-padding-y = "10,0";
    } // (
      if stdenv.isDarwin then
        {
          macos-titlebar-style = "hidden";
        }
      else
        {
          window-decoration = "none";
          window-padding-x = 5;
        }
    );
  };
}
