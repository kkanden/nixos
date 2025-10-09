{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.oliwia = {
    xdgPortal.enable = lib.mkEnableOption "XDG Portal";
  };
  config = lib.mkIf config.oliwia.xdgPortal.enable {
    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      xdgOpenUsePortal = true;
      config = {
        common.default = [ "gtk" ];
      };
    };
  };
}
