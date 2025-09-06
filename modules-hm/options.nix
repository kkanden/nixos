{
  lib,
  config,
  ...
}:
let
  inherit (lib) types;
  mkConfig = path: {
    source = config.lib.file.mkOutOfStoreSymlink ("/etc/nixos/config/" + path);
    recursive = true;
  };
in
{
  options.oliwia = {
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
    xdg.configFile = (builtins.mapAttrs (_: mkConfig) config.oliwia.configSymlink);
  };
}
