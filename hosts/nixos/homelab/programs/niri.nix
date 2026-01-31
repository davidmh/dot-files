{ pkgs, config, ... }:

{
  home.packages = with pkgs; [ niri swayidle ];
  programs.niriswitcher = {
    enable = true;
    settings = {
      keys = {
        modifier = "Super";
        switch = {
          next = "Tab";
          prev = "Shift+Tab";
        };
      };
      center_on_focus = true;
      appearance = {
        system_theme = "dark";
        icon_size = 64;
      };
    };
  };

  xdg.configFile."niri/config.kdl".source = config.lib.file.mkOutOfStoreSymlink "${config.custom.dotfiles}/config/niri.kdl";
}
