{ lib, ... }:

{
  options.custom = {
    dotfiles = lib.mkOption {
      type = lib.types.str;
      description = "The absolute path to the dotfiles directory on the host system.";
      default = "/home/homelab/.config/nixos";
    };
  };
}
