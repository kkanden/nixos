{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.oliwia = {
    steam.enable = lib.mkEnableOption "Steam with extra stuff";
  };
  config = lib.mkIf config.oliwia.steam.enable {
    programs.steam = {
      enable = true;
      package = pkgs.steam.override {
        extraPkgs = (
          pkgs: with pkgs; [
            gamemode
          ]
        );
      };
      gamescopeSession.enable = true;
    };

    environment.systemPackages = with pkgs; [
      mangohud
      protonup
      protonup-qt
      (bottles.override { removeWarningPopup = true; })
    ];
    environment.sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATH = "/home/oliwia/.steam/compatibilitytools.d";
    };

    programs.gamemode.enable = true;
  };
}
