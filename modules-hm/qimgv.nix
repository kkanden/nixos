{ lib', ... }:
{
  xdg.configFile."qimgv/qimgv.conf".source = lib'.mkConfig "qimgv/qimgv.conf";
  xdg.configFile."qimgv/theme.conf".source = lib'.mkConfig "qimgv/theme.conf";
}
