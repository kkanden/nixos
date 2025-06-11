{
  description = "oliwia flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-stable, home-manager }@inputs:
  let 
  	system = "x86_64-linux";
	in
  {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem{
      system = system;
      specialArgs = inputs;
      modules = [
	      ./configuration.nix
	     ./hardware-configuration.nix
	     home-manager.nixosModules.home-manager
	     {
	     home-manager.useGlobalPkgs = true;
	     home-manager.useUserPackages = true;
	     home-manager.users.oliwia = ./home.nix;
	     }

          {
            nixpkgs.overlays = [
              (final: prev: { stable = import nixpkgs-stable { inherit (prev) system; }; })
            ];
          }
      ];
    };
  };
}
