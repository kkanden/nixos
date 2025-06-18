{
  config,
  lib,
  pkgs,
  ...
}:
{
  wayland.windowManager.hyprland = {
    enable = true;
    package = null; # both nulls are required to avoid conflict with the nixos module
    portalPackage = null;
    extraConfig = builtins.readFile ../config/hypr/hyprland.conf;
    systemd = {
      enable = false;
      variables = [ "--all" ];
    };
    plugins = with pkgs.hyprlandPlugins; [
      csgo-vulkan-fix
    ];
  };

  programs.hyprlock = {
    enable = true;
    settings = {
      animations.enabled = false;
      image.monitor = "DP-2";
    };
  };

  services.hypridle = {
    enable = true;

    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };

      listener = [
        {
          timeout = 900;
          on-timeout = "hyprlock";
        }
        {
          timeout = 900;
          on-timeout = "hyprctl dispatch dpms off";

          on-resume = "hyprctl dispatch dpms on";
        }
        {
          timeout = 1800;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };

  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [ "~/wallpapers/idk.png" ];
      wallpaper = [
        "DP-2,~/wallpapers/idk.png"
        "HDMI-A-1,~/wallpapers/idk.png"
      ];
    };

  };

  home.file."scripts/focus-or-launch" = {
    source = ../scripts/focus-or-launch;
    executable = true;
  };
  home.file."scripts/killactive-steamsafe" = {
    source = ../scripts/killactive-steamsafe;
    executable = true;
  };
}
