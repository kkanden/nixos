{ pkgs, ... }:

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
      dpi = 120;

      display-drun = "";
      drun-display-format = "{name} <span weight='light' size='small' foreground='#606079'><i>{generic}</i></span>";
      drun-match-fields = "name,generic";

      close-on-delete = false;
      matching = "fuzzy";

      kb-delete-entry = "Control+x";
      kb-cancel = "Escape,Control+c";
      kb-secondary-copy = "";
      kb-entry-history-up = "Control+j";
      kb-remove-to-eol = "";
      kb-entry-history-down = "Control+k";
      kb-accept-entry = "Control+b,Return,KP_Enter";
      kb-move-char-back = "Left";
    };
  };

  home.file."scripts/rofi-search" = {
    source = ../scripts/rofi-search;
    executable = true;
  };
}
