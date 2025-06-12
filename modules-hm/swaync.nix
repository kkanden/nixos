{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.swaync = {
    enable = true;
    settings = builtins.fromJSON (builtins.readFile ../config/swaync/config.json);
  };
}
