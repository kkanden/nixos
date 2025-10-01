{
  lib,
  config,
  configPath,
  ...
}:
let
  cfg = config.oliwia.home;
  inherit (lib) types;
  mkSymlink =
    targetPath: sourcePath:
    let
      fullPath = "${configPath}/${sourcePath}";
      pathType = lib.pathType fullPath;
      repoConfigPathStr = "${cfg.repoPath}/config";
    in
    if pathType == "regular" then
      {
        "${targetPath}" = {
          source = config.lib.file.mkOutOfStoreSymlink "${repoConfigPathStr}/${sourcePath}";
        };
      }
    else if pathType == "directory" then
      let
        dirContents = lib.filesystem.listFilesRecursive fullPath;
        mkRelative = file: lib.removePrefix "${fullPath}/" (toString file);
        fileAttrs = builtins.listToAttrs (
          map (file: {
            name = builtins.unsafeDiscardStringContext "${targetPath}/${mkRelative file}"; # string context comes from file being a nix store path
            value = {
              source = config.lib.file.mkOutOfStoreSymlink "${repoConfigPathStr}/${sourcePath}/${mkRelative file}";
            };
          }) dirContents
        );
      in
      fileAttrs
    else
      throw "Invalid config path: ${sourcePath}";
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
    xdg.configFile = lib.mkMerge (lib.mapAttrsToList mkSymlink cfg.configSymlink);
  };
}
