{ pkgs, ... }:
{
  xdg.configFile."keyd/app.conf".text = ''
    [zen]

    control.w = C-backspace
  '';
}
