{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.alacritty = {
    enable = true;
    settings = builtins.fromTOML (builtins.readFile ../config/alacritty/alacritty.toml);
  };
  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = builtins.readFile ../config/hypr/hyprland.conf;
  };
}
