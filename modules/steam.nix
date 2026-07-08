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
      extraCompatPackages = [
        pkgs.proton-ge-bin
      ];
    };

    environment.systemPackages = with pkgs; [
      mangohud
      (bottles.override { removeWarningPopup = true; })
    ];

    programs.gamemode.enable = true;
  };
}
