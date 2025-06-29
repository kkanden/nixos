{ ... }:
{
  programs.alacritty = {
    enable = true;
    settings = builtins.fromTOML (builtins.readFile ../config/alacritty/alacritty.toml);
  };
}
