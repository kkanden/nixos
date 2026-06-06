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
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    kanden-website = {
      url = "git+https://git.kanden.me/website";
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
      lib' = import ./lib;
      system = "x86_64-linux";
      specialArgs = {
        inherit
          inputs
          system
          lib'
          repoPath
          repoPathStr
          ;
      };
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
            inputs.sops-nix.nixosModules.sops
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
