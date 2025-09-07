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
    scriptSymlink = {
      enable = lib.mkEnableOption "Symlink scripts folder";
      path = lib.mkOption {
        type = types.str;
        default = "scripts";
        description = "Path to scripts folder inside repoPath";
      };
    };
  };
  config = {
    xdg.configFile = (builtins.mapAttrs (_: mkConfig) cfg.configSymlink);
    home.file = lib.mkIf cfg.scriptSymlink.enable {
      scripts = mkSymlink "scripts";
    };
  };
}
