{ pkgs, config, ... }: {

  imports = [
    ../../shared/base.nix
    ../../shared/programs/direnv.nix
    ../../shared/programs/ghostty.nix
    ../../shared/programs/git.nix
    ../../shared/programs/neovim.nix
    ../../shared/programs/shell.nix
    ../../shared/programs/starship.nix
    ../../shared/programs/zellij.nix
  ];

  home.packages = with pkgs; [
    aerospace
    jankyborders

    # remix
    colima
    docker
    docker-compose
    postgresql_16
    redis
  ] ++ import ../../shared/packages.nix { pkgs = pkgs; };

  xdg.configFile."aerospace/aerospace.toml".source = config.lib.file.mkOutOfStoreSymlink "${config.custom.dotfiles}/config/aerospace.toml";
}
