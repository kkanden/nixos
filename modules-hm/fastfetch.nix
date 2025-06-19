{ lib', ... }:
{
  programs.fastfetch = {
    enable = true;
    settings = builtins.fromJSON (lib'.readConfig "fastfetch/config.jsonc");
  };
}
