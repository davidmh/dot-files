{ inputs, ... }: {
  imports = [
    ../../configuration.nix
    ../../login.nix
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.users.root = {
        imports = [
          ../../shared/base.nix
          ../../shared/options.nix
          ../../shared/programs/git.nix
          ../../shared/programs/neovim.nix
        ];
      };
      home-manager.users.homelab = ./homelab/default.nix;
      home-manager.extraSpecialArgs = { inherit inputs; };
    }
  ];

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      inputs.niri.overlays.default
    ];
  };

  programs.niri.enable = true;
  programs.git.enable = true;
}
