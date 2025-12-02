{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) types mkOption;
  cfg = config.oliwia.hyprland;
  hypr-plugin-dir = pkgs.symlinkJoin {
    name = "hyrpland-plugins";
    paths = with pkgs.hyprlandPlugins; [
      csgo-vulkan-fix
    ];
  };
in
{
  # monitor = DP-2, 1920x1080@75, 0x0, 1
  # monitor = HDMI-A-1, preferred, -1920x120, 1
  options.oliwia.hyprland = {
    enable = lib.mkEnableOption "Hyprland with utilities";
    monitors = mkOption {
      default = [ ];
      type = types.listOf (
        types.submodule {
          options =
            let
              mkOpt =
                opts:
                mkOption {
                  type = types.str;
                  default = "";
                }
                // opts;
            in
            {
              name = mkOpt {
                type = types.nullOr (types.strMatching ".+");
                default = null;
              };
              res = mkOpt { default = "preferred"; };
              pos = mkOpt { default = "auto"; };
              scaling = mkOpt { default = "1"; };
              main = mkOption {
                type = types.bool;
                default = false;
              };
            };
        }
      );
    };
  };

  config =
    let
      monitors = cfg.monitors;
      hasMultipleMonitors = lib.length monitors > 1;
      mainDisplay = lib.optionalString (monitors != [ ]) (
        monitors |> lib.filter (m: m.main) |> lib.head |> (m: m.name)
      );
      # first non-main display
      secondDisplay = lib.optionalString hasMultipleMonitors (
        monitors |> lib.filter (m: !m.main) |> lib.head |> (m: m.name)
      );
      workspaceAssignment =
        "\n"
        + lib.optionalString hasMultipleMonitors (
          (lib.range 1 9)
          |> lib.map (
            n: "workspace = ${builtins.toString n}, monitor:${if n == 1 then secondDisplay else mainDisplay}"
          )
          |> lib.concatStringsSep "\n"
        );
    in
    lib.mkMerge [
      {
        assertions = [
          {
            assertion = (monitors != [ ]) -> (lib.count (m: m.main) monitors) == 1;
            message = "oliwia.hyprland.monitors: one (and only one) main monitor must be configured!";
          }
          {
            assertion = lib.all (m: m.name != null) monitors;
            message = "oliwia.hyprland.monitors: a monitor must have a name defined!";
          }
        ];
      }
      {
        environment.sessionVariables.MAIN_DISPLAY = mainDisplay;
        environment.sessionVariables.MAIN_DISPLAY_ROFI = "'${mainDisplay}'"; # rofi needs extra quotes to deal with env variables
        # file to be sourced in hyprland.conf
        environment.etc."hypr/monitors.hypr".text =
          (lib.optionalString (cfg.monitors != [ ]) (
            cfg.monitors
            |> lib.map (opts: with opts; "monitor=${name},${res},${pos},${scaling}")
            |> lib.concatStringsSep "\n"
          ))
          + workspaceAssignment;
      }
      (lib.mkIf cfg.enable {
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
      })
    ];
}
