{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.oliwia.fish;
in
{

  options.oliwia.fish = {
    enable = lib.mkEnableOption "fish as login shell";
    stable = lib.mkEnableOption "overlaying the fish package with the stable one.";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      programs.fish.enable = true;
      users.users.oliwia.shell = pkgs.fish;
    })
    (lib.mkIf cfg.stable {
      nixpkgs.overlays = [
        (final: prev: {
          fish = prev.pkgs.stable.fish;
          fishPlugins = prev.pkgs.stable.fishPlugins;
        })
      ];
    })
  ];
}
