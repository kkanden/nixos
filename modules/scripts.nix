{
  config,
  lib,
  pkgs,
  scriptsPath,
  ...
}:
let
  cfg = config.oliwia.scripts;
  inherit (lib) types;
in
{
  options.oliwia = {
    scripts = {
      scripts = lib.mkOption {
        type = types.attrsOf (
          types.submodule {
            options = {
              name = lib.mkOption {
                description = "Target executable name (defaults to script file name).";
                type = types.nullOr types.str;
                default = null;
              };
              dependencies = lib.mkOption {
                description = "Dependencies of the script.";
                type = types.listOf types.package;
                default = [ ];
              };
            };
          }
        );
        default = { };
        description = ''
          Attribute set containing the defintions of scripts. The
          keys is the script file name inside the scripts folder. The values are
          submodules containing the target name of the executable (defaults to
          the key) and its dependencies
        '';
        example = lib.literalExpression ''
          {
            filename-in-scripts = {
              name = my-script;
              dependencies = [pkgs.hello pkgs.cowsay];
            } ;
          }
        '';
      };
    };
  };
  config =
    let
      removeShebang = raw-script: lib.removePrefix "#!/usr/bin/env bash\n" raw-script;
      scriptPkgs = lib.mapAttrsToList (
        script-name:
        {
          name,
          dependencies,
        }:
        pkgs.writeShellApplication {
          name = if name != null then name else script-name;
          runtimeInputs = dependencies;
          text = removeShebang builtins.readFile (scriptsPath + "/${script-name}");
          excludeShellChecks = [
            "SC2086" # Double quote to prevent globbing and word splitting -- sometimes i want it unquoted
            "SC2016" # Expressions don't expand in single quotes, use double quotes for that.
          ];
          bashOptions = [ ]; # errexit, nounset, pipefail by default and it's annoying
        }
      ) cfg.scripts;
    in
    lib.mkMerge [
      (lib.mkIf (cfg.scripts != { }) {
        environment.systemPackages = scriptPkgs;
      })
    ];
}
