{
  description = "oliwia flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-stable,
      home-manager,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      libExtra = {
        configPath = ./config;
        scriptsPath = ./scripts;
      };
      root = ./.;
      lib' = import ./lib ({ inherit (nixpkgs) lib; } // libExtra);
      specialArgs = {
        inherit
          inputs
          system
          lib'
          root
          ;
      }
      // libExtra;
    in
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system specialArgs;
        modules = [
          ./configuration.nix
          ./hardware-configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.oliwia = ./home.nix;
              backupFileExtension = "hm-backup";
              extraSpecialArgs = specialArgs;
            };
          }

          {
            nixpkgs.overlays = [
              (final: prev: {
                stable = import nixpkgs-stable {
                  inherit (prev) system;
                  config.allowUnfree = true;
                };
              })
            ];
          }

        ];
      };
    };
}
