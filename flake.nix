{
  description = "Home Manager configuration of david.mejorado";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      username = builtins.getEnv "USER";
      homeDirectory = builtins.getEnv "HOME";
    in {
      # is this legal? 🤷
      homeConfigurations."${username}" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${builtins.currentSystem};
        modules = [
          ./home.nix
          {
            home.username = username;
            home.homeDirectory = homeDirectory;
          }
        ];
      };
    };
}
