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
      firefox
      walker
      discord-ptb
      ;
    zen = self.inputs.zen-browser.packages.${pkgs.system}.default;
  };
}
