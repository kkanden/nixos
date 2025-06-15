{ config, pkgs, ... }:

{
  home.packages = [ pkgs.rofi-power-menu ];
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    plugins = with pkgs; [
      (rofi-calc.override { rofi-unwrapped = rofi-wayland-unwrapped; })
    ];
    modes = [
      "drun"
      "window"
      "calc"
    ];
    terminal = "alacritty";
    font = "JetBrainsMono Nerd Font 16";
    theme = ../config/rofi/vague.rasi;
    extraConfig = {
      show-icons = true;
      icon-theme = "Papirus";
      display-drun = "";
      drun-display-format = "{icon} {name}";
    };
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
