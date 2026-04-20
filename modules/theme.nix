{
  pkgs,
  lib,
  config,
  ...
}:
let
  defaultGtk = ''
    [Settings]
    gtk-application-prefer-dark-theme=true
    gtk-theme-name=Vague
    gtk-icon-theme-name=Papirus
    gtk-cursor-theme-name=phinger-cursors-dark
    gtk-cursor-theme-size=24
  '';
in
{
  options.oliwia.theme.enable = lib.mkEnableOption "default theming";

  config = lib.mkIf config.oliwia.theme.enable {
    environment.systemPackages = with pkgs; [
      phinger-cursors
      papirus-icon-theme
      vague-gtk
    ];

    # qt
    qt = {
      enable = true;
      platformTheme = "gtk2";
      style = "adwaita-dark";
    };

    # gtk
    programs.dconf = {
      enable = true;
      profiles.user.databases = [
        {
          settings = {
            "org/gnome/desktop/interface" = {
              color-scheme = "prefer-dark";
              gtk-theme = "Vague";
            };
          };
        }
      ];
    };
    environment.etc."gtk-3.0/settings.ini".text = defaultGtk;
    environment.etc."gtk-4.0/settings.ini".text = defaultGtk;

    # cursor
    environment.sessionVariables = {
      XCURSOR_SIZE = 24;
      XCURSOR_THEME = "phinger-cursors-dark";
      HYPRCURSOR_SIZE = 24;
      HYPRCURSOR_THEME = "phinger-cursors-dark";
    };

    system.activationScripts.gtk4-vague = {
      text = ''
        mkdir -p /home/oliwia/.config/gtk-4.0 
        ln -sf ${pkgs.vague-gtk}/share/themes/Vague/gtk-4.0/gtk-dark.css /home/oliwia/.config/gtk-4.0/gtk.css
      '';
      deps = [
        "users"
        "groups"
      ];
    };
    system.activationScripts.cursor = {
      text = ''
        mkdir -p /home/oliwia/.icons/default
        cat > /home/oliwia/.icons/default/index.theme <<EOF
        [Icon Theme]
        Name=Default
        Comment=Default cursor theme
        Inherits=phinger-cursors-dark
        EOF
      '';
      deps = [
        "users"
        "groups"
      ];
    };
  };
}
