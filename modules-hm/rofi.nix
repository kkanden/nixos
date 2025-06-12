{ inputs, pkgs, ... }:

{
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
}
