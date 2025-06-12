{
  self,
  config,
  lib,
  pkgs,
  ...
}:
{
  environment.systemPackages = builtins.attrValues {
    inherit (pkgs)
      wl-clipboard
      fuzzel
      cliphist
      firefox
      discord-ptb
      spotify
      ;
    zen = self.inputs.zen-browser.packages.${pkgs.system}.default;
  };
}
