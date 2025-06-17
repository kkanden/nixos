{ pkgs, ... }:
{
  environment.variables = {
    NIXOS_OZONE_WL = "1";
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    xdgOpenUsePortal = true;
    config = {
      common.default = [ "gtk" ];
    };
  };
}
