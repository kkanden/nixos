{ pkgs, ... }:
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
        serif = [ "Open Serif" ];
        sansSerif = [ "Lato" ];
        monospace = [ "JetBrainsMono Nerd Font" ];
      };
    };
  };
}
