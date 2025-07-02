{
  pkgs,
  lib,
  lib',
  ...
}:
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
      {
        name = "power_menu";
        path = lib.getExe pkgs.rofi-power-menu;
      }

    ];
    terminal = "alacritty";

    theme = lib'.mkConfig "rofi/vague.rasi";
    extraConfig = {
      show-icons = true;
      icon-theme = "Papirus";
      dpi = 120;

      drun-display-format = "{name}";
      drun-match-fields = "name";
      combi-hide-mode-prefix = true;

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
    source = lib'.mkScript "rofi-search";
    executable = true;
  };
}
