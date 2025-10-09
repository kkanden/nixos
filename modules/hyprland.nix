{
  config,
  pkgs,
  lib,
  ...
}:
let
  hypr-plugin-dir = pkgs.symlinkJoin {
    name = "hyrpland-plugins";
    paths = with pkgs.hyprlandPlugins; [
      csgo-vulkan-fix
    ];
  };
in
{
  options.oliwia = {
    hyprland.enable = lib.mkEnableOption "Hyprland with utilities";
  };
  config = lib.mkIf config.oliwia.hyprland.enable {
    environment.sessionVariables = {
      HYPR_PLUGIN_DIR = hypr-plugin-dir;
    };
    environment.systemPackages = with pkgs; [
      hyprpolkitagent
      hyprpicker
      hyprpaper
      hyprsysteminfo
      hyprland-qt-support
      hyprland-qtutils
      hyprcursor
      rose-pine-hyprcursor
    ];

    programs.hyprland = {
      enable = true;
      # required for screen sharing to work
      xwayland.enable = true;
      withUWSM = true;
    };

    programs.hyprlock.enable = true;
    services.hypridle.enable = true;

    environment.loginShellInit = # bash
      ''
        if uwsm check may-start; then
            exec uwsm start hyprland-uwsm.desktop
        fi
      '';
  };
}
