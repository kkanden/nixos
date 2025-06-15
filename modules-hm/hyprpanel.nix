# *.nix
{ pkgs, ... }:
{
  home.packages = [ pkgs.hyprpanel ];

  xdg.configFile."hyprpanel/config.json".source = ../config/hypr/hyprpanel.json;
}
