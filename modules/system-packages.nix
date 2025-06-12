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
      libqalculate
      cliphist
      firefox
      discord-ptb
      spotify

      thunderbird-latest-unwrapped
      ;
    zen = self.inputs.zen-browser.packages.${pkgs.system}.default;
  };
}
