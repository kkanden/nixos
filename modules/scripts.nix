{
  config,
  lib,
  pkgs,
  root,
  ...
}:
let
  cfg = config.oliwia.scripts;
  inherit (lib) types;
in
{
  options.oliwia = {
    scripts = {
      # enable = lib.mkEnableOption "Symlink scripts folder";
      path = lib.mkOption {
        type = types.str;
        default = "scripts";
        description = "Path to scripts folder inside root";
      };
      definitions = lib.mkOption {
        type = types.attrsOf (types.listOf types.package);
        default = { };
        description = "Attribute set with script names as keys and their
        dependencies as the values. The source file will be taken as
        '\${oliwia.scripts.path}/scripts-name' relative to NixOS configuration
        folder (`root` defined in the flake).";
        example = lib.literalExpression ''
          {
              script-name = [pkgs.hello pkgs.cowsay];
          }
        '';
      };
    };
  };
  config =
    let
      removeShebang = raw-script: lib.removePrefix "#!/usr/bin/env bash\n" raw-script;
      scriptPkgs = lib.mapAttrsToList (
        script-name: deps:
        pkgs.writeShellApplication {
          name = script-name;
          runtimeInputs = deps;
          text = removeShebang (builtins.readFile (builtins.toPath "${root}/${cfg.path}/${script-name}"));
          excludeShellChecks = [ "SC2086" ]; # Double quote to prevent globbing and word splitting -- sometimes i want it unquoted
          bashOptions = [ ]; # errexit, nounset, pipefail by default and it's annoying
        }
      ) cfg.definitions;
    in
    lib.mkMerge [
      (lib.mkIf (cfg.definitions != { }) {
        environment.systemPackages = scriptPkgs;
      })
    ];
}
