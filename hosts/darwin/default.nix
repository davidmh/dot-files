{ ... }: {
  imports = [
    ./configuration.nix
    ../../shared/options.nix
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
    overlays = [ ];
  };

  custom.dotfiles = "/Users/david.mejorado/.config/home-manager";

  home = {
    username = "david.mejorado";
    homeDirectory = "/Users/david.mejorado";
  };
}
