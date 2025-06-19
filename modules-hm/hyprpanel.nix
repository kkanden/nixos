{ lib', pkgs, ... }:
{
  home.packages = [ pkgs.hyprpanel ];

  xdg.configFile."hyprpanel/config.json".source = lib'.mkConfig "hypr/hyprpanel.json";
}
