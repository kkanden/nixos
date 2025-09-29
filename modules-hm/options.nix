{
  lib,
  config,
  ...
}:
let
  cfg = config.oliwia.home;
  inherit (lib) types;
  mkSymlink = path: {
    source = config.lib.file.mkOutOfStoreSymlink "${cfg.repoPath}/${path}";
    recursive = true;
  };
  mkConfig = path: mkSymlink "/config/${path}";
in
{
  options.oliwia.home = {
    repoPath = lib.mkOption {
      type = types.str;
      default = "/etc/nixos";
    };
    configSymlink = lib.mkOption {
      type = types.attrsOf types.str;
      example = lib.literalExpression ''
        {
            "path/in/.config" = "path/to/source";
        }
      '';
    };
  };
  config = {
    xdg.configFile = (builtins.mapAttrs (_: mkConfig) cfg.configSymlink);
  };
}
