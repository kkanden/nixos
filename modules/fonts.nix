{
  pkgs,
  ...
}:
{
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      liberation_ttf
      open-sans
      roboto
      lato
      nerd-fonts.jetbrains-mono
    ];
    fontconfig = {
      defaultFonts = {
        serif = [ "Liberation Serif" ];
        sansSerif = [ "Open Sans" ];
        monospace = [ "JetBrainsMono Nerd Font" ];
      };
    };
  };
}
