{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-23.11-darwin";
    unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, unstable, home-manager, ... }@inputs:
    let
      system = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages.${system};
      username = "david.mejorado";
      homeDirectory = "/Users/david.mejorado";
    in
    {
      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [
          {
            nixpkgs = {
              config = {
                allowUnfree = true;
                allowUnfreePredicate = (pkgs: true);
              };
              overlays = [
                (final: prev: {
                  unstable = import inputs.unstable {
                    system = final.system;
                    config.allowUnfree = true;
                  };
                })
              ];
            };
          }
          ./home.nix
          {
            home.username = username;
            home.homeDirectory = homeDirectory;
            home.stateVersion = "23.11";
          }
        ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
        extraSpecialArgs = {
          inherit inputs;
        };
      };
    };
}
