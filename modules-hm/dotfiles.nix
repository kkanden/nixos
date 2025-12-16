# ai generated docs because i'm lazy

# this module allows declarative config file management where host-specific configs
# take precedence over global ones. for example:
#   - global config: ./config/hyprland/hyprland.conf
#   - host override: ./hosts/myhost/config/hyprland/hyprland.conf
#
# if the host-specific file exists, it will be used; otherwise falls back to global.

# IMPLEMENTATION NOTES:
# - we maintain both nix paths and string paths throughout:
#   * nix paths (repoPath, hostPath, globalPath): required for pathExists,
#     pathType, listFilesRecursive which only work with nix paths
#     in pure evaluation mode
#   * string paths (*PathStr): required for mkOutofStoreSymlink, which needs an
#     absolute string path to create the symlink target
# - the mkRelative function uses toString on fullPath because listFilesRecursive
#   returns store paths, and we need consistent string representations for prefix removal

{
  lib,
  config,
  repoPath,
  repoPathStr,
  osConfig,
  ...
}:
let
  cfg = config.oliwia.home;
  inherit (lib) types;

  hostname = osConfig.networking.hostName;
  hostPathStr = repoPathStr + "/hosts/${hostname}/config";
  hostPath = repoPath + "/hosts/${hostname}/config";
  globalPathStr = repoPathStr + "config";
  globalPath = repoPath + "/config";

  mkSymlink =
    targetPath: sourcePath:
    let
      hostFullStr = "${hostPathStr}/${sourcePath}";
      hostFull = hostPath + "/${sourcePath}";
      globalFullStr = "${globalPathStr}/${sourcePath}";
      globalFull = globalPath + "/${sourcePath}";

      useHostSpecific = builtins.pathExists hostFull;
      fullPathStr = if useHostSpecific then hostFullStr else globalFullStr;
      fullPath = if useHostSpecific then hostFull else globalFull;

      pathType = lib.pathType fullPath;
    in
    if pathType == "regular" then
      {
        "${targetPath}" = {
          source = config.lib.file.mkOutOfStoreSymlink fullPathStr;
        };
      }
    else if pathType == "directory" then
      let
        dirContents = lib.filesystem.listFilesRecursive fullPath;
        mkRelative = file: lib.removePrefix "${toString fullPath}/" (toString file);
        fileAttrs = builtins.listToAttrs (
          map (file: {
            name = builtins.unsafeDiscardStringContext "${targetPath}/${mkRelative file}";
            value = {
              source = config.lib.file.mkOutOfStoreSymlink "${fullPathStr}/${mkRelative file}";
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
