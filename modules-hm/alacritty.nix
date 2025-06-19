{ lib', ... }:
{
  programs.alacritty = {
    enable = true;
    settings = builtins.fromTOML (lib'.readConfig "alacritty/alacritty.toml");
  };
}
