{ pkgs, ... }:
{
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
}
