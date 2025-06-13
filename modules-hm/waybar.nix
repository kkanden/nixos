{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.waybar = {
    enable = true;
  };
  xdg.configFile."waybar/config.jsonc".source = ../config/waybar/config.json;
  xdg.configFile."waybar/style.css".source = ../config/waybar/style.css;
}
