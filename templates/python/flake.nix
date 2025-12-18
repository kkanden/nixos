{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs =
    { nixpkgs, ... }:
    let
      forAllSystems = nixpkgs.lib.genAttrs [
        "x86_64-linux"
      ];
    in
    {
      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          ld_libs = with pkgs; [ ];
        in
        {
          ${system}.default = pkgs.mkShell {
            packages = with pkgs; [
              python
              uv
            ];
            LD_LIBRARY_PATH = "${pkgs.lib.makeLibraryPath ld_libs}";
            shellHook = ''
              export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$NIX_LD_LIBRARY_PATH"
              unset PYTHONPATH
              uv sync
              . .venv/bin/activate
              exec fish
            '';
          };
        }
      );
    };
}
