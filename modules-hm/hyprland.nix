{ pkgs, lib', ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;
    package = null; # both nulls are required to avoid conflict with the nixos module
    portalPackage = null;
    extraConfig = lib'.readConfig "hypr/hyprland.conf";
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
      background = [
        {
          monitor = "DP-2";
          color = "rgb(141415)";
        }
        {
          monitor = "HDMI-A-1";
          color = "rgb(141415)";
        }
      ];

      label = [
        {
          monitor = "DP-2";
          text = "$TIME";
          color = "rgb(cdcdcd)";
          font_size = 95;
          position = "0, 300";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "DP-2";
          text = ''cmd[update:1000] echo $(date +"%A, %B %d")'';
          color = "rgb(cdcdcd)";
          font_size = 22;
          position = "0, 200";
          halign = "center";
          valign = "center";

        }
      ];

      input-field = {
        monitor = "DP-2";
        size = "200,50";
        outline_thickness = 2;
        dots_size = 0.2; # Scale of input-field height, 0.2 - 0.8
        dots_spacing = 0.35; # Scale of dots' absolute size, 0.0 - 1.0
        dots_center = true;
        outer_color = "rgb(cdcdcd)";
        inner_color = "rgb(252530)";
        font_color = "rgb(aeaed1)";
        fade_on_empty = false;
        rounding = 0;
        check_color = "rgb(cdcdcd)";
        fail-color = "rgb(d8647e)";
        placeholder_text = "";
        hide_input = false;
        position = "0, -100";
        halign = "center";
        valign = "center";
      };
    };
  };

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        after_sleep_cmd = "hyprctl dispatch dpms on";
        ignore_dbus_inhibit = false;
        lock_cmd = "hyprlock";
      };

      listener = [
        {
          timeout = 900;
          on-timeout = "loginctl lock-session";
        }
        # {
        #   timeout = 1200;
        #   on-timeout = "hyprctl dispatch dpms off";
        #   on-resume = "hyprctl dispatch dpms on";
        # }
      ];
    };
  };

  services.hyprpaper =
    let
      wallpaper_path = "~/wallpapers/minsky.png";
    in
    {
      enable = true;
      settings = {
        preload = [ wallpaper_path ];
        wallpaper = [
          "DP-2,${wallpaper_path}"
          "HDMI-A-1,${wallpaper_path}"
        ];
      };

    };

  home.file."scripts/focus-or-launch" = {
    source = lib'.mkScript "focus-or-launch";
    executable = true;
  };
  home.file."scripts/killactive-steamsafe" = {
    source = lib'.mkScript "killactive-steamsafe";
    executable = true;
  };
}
