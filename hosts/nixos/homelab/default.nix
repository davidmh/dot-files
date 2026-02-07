{ pkgs, inputs, ... }:
let
  username = "homelab";
  homeDirectory = "/home/${username}";
in
{
  imports = [
    # inputs.dms.homeModules.dank-material-shell
    # ./programs/dms.nix
    inputs.noctalia.homeModules.default
    ./programs/noctalia.nix
    ./programs/fonts.nix
    ./programs/niri.nix
    ../../../shared/base.nix
    ../../../shared/programs/direnv.nix
    ../../../shared/programs/ghostty.nix
    ../../../shared/programs/git.nix
    ../../../shared/programs/neovim.nix
    ../../../shared/programs/shell.nix
    ../../../shared/programs/starship.nix
    ../../../shared/options.nix
  ];

  home = {
    username = username;
    homeDirectory = homeDirectory;
  };

  home.packages = with pkgs; [
    gnome-font-viewer
    protonvpn-gui

    # messaging
    telegram-desktop
    signal-desktop

    # file explorer
    nautilus

    # notifications
    libnotify
  ] ++ import ../../../shared/packages.nix { pkgs = pkgs; };
}
