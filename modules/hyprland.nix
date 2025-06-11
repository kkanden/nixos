{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.kitty.enable = true;
  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = builtins.readFile ../config/hypr/hyprland.conf;
  };
}
