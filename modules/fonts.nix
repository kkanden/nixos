{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.oliwia = {
    fonts.enable = lib.mkEnableOption "fonts";
  };
  config = lib.mkIf config.oliwia.fonts.enable {
    fonts = {
      enableDefaultPackages = true;
      packages = with pkgs; [
        liberation_ttf
        open-sans
        roboto
        lato
        font-awesome
        newcomputermodern
        source-sans-pro
        nerd-fonts.jetbrains-mono
        corefonts
      ];
      fontconfig = {
        defaultFonts = {
          serif = [ "Open Serif" ];
          sansSerif = [ "Lato" ];
          monospace = [ "JetBrainsMono Nerd Font" ];
        };
      };
    };
  };
}
