{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };

  environment.systemPackages = with pkgs; [
    mangohud
    protonup
    bottles
  ];
  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATH = "/home/oliwia/.steam/compatibilitytools.d";
  };

  programs.gamemode.enable = true;
}
