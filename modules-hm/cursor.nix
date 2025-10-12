{ pkgs, ... }:
{
  home.pointerCursor = {
    enable = true;
    package = pkgs.phinger-cursors;
    name = "phinger-cursors-dark";
    size = 24;
    gtk.enable = true;
    hyprcursor.enable = true;
  };
}
