{
  description = "oliwia flake";

  nixConfig = {
    experimental-features = [
      "nix-command"
      "flakes"
      "pipe-operator"
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      ...
    }@inputs:
    let
      repoPath = ./.;
      repoPathStr = "/etc/nixos";
      libExtra = {
        configPath = ./config;
        scriptsPath = ./scripts;
      };
      lib' = import ./lib ({ inherit (nixpkgs) lib; } // libExtra);
      system = "x86_64-linux";
      specialArgs = {
        inherit
          inputs
          system
          lib'
          repoPath
          repoPathStr
          ;
      }
      // libExtra;
      mkHost = host: {
        name = host;
        value = nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          modules = (nixpkgs.lib.filesystem.listFilesRecursive ./modules) ++ [
            ## GLOBALS ##
            ./configuration.nix
            {
              environment.sessionVariables.NIXOS_REPO = repoPathStr;
              nixpkgs.overlays = [
                (import ./overlays.nix { inherit inputs system; })
              ];
            }
            inputs.nix-index.nixosModules.default
            ## HOST SPECIFIC ##
            ./hosts/${host}/configuration.nix
            {
              networking.hostName = host;
            }
          ];

        };
      };
    in
    {
      nixosConfigurations = builtins.listToAttrs (
        map mkHost (builtins.attrNames (builtins.readDir ./hosts))
      );
      templates = {
        python = {
          path = ./templates/python;
          description = "Python impure template";
        };
      };
    };
}
