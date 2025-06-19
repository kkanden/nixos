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
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprpanel.url = "github:Jas-SinghFSU/HyprPanel";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-stable,
      home-manager,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      lib' = import ./lib {
        inherit (nixpkgs) lib;
        configPath = ./config;
      };
      specialArgs = {
        inherit inputs system lib';
        configPath = ./config;
      };
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
              extraSpecialArgs = specialArgs;
            };
          }

          {
            nixpkgs.overlays = [
              (final: prev: { stable = import nixpkgs-stable { inherit (prev) system; }; })
              inputs.hyprpanel.overlay
            ];
          }

        ];
      };
    };
}
