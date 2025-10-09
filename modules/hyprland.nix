{ pkgs, lib, ... }:
with lib;
let
  hypr-plugin-dir = pkgs.symlinkJoin {
    name = "hyrpland-plugins";
    paths = with pkgs.hyprlandPlugins; [
      csgo-vulkan-fix
    ];
  };
in
{
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
}
