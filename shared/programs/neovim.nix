{ config, inputs, lib, pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    plugins = lib.mkForce [ ];
    withRuby = false;
    withPython3 = false;
    withNodeJs = false;
    package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
  };

  xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.custom.dotfiles}/nvim";
}
