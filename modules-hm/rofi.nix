{ inputs, pkgs, ... }:

{
  home.packages = [ pkgs.rofi-power-menu ];
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    plugins = with pkgs; [
      (rofi-calc.override { rofi-unwrapped = rofi-wayland-unwrapped; })
    ];
    theme = "gruvbox-dark-hard";
    modes = [
      "drun"
      "window"
      "calc"
    ];
    terminal = "alacritty";
  };

  home.file."scripts/rofi-audio" = {
    source = ../scripts/rofi-audio;
    executable = true;
  };

  home.file."scripts/rofi-search" = {
    source = ../scripts/rofi-search;
    executable = true;
  };
}
