{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) types mkOption;
  cfg = config.oliwia.hyprland;
in
{
  # monitor = DP-2, 1920x1080@75, 0x0, 1
  # monitor = HDMI-A-1, preferred, -1920x120, 1
  options.oliwia.hyprland = {
    enable = lib.mkEnableOption "Hyprland with utilities";
    autoStartup = lib.mkEnableOption "Hyprland UWSM autostartup";
    plugins = lib.mkOption {
      type = types.listOf types.package;
      default = [ ];
    };
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
    extraConfig = lib.mkOption {
      type = types.lines;
      default = "";
    };
  };

  config =
    let
      hyprPluginsJoin = pkgs.symlinkJoin {
        name = "hyprland-plugins";
        paths = cfg.plugins;
      };
      loadPluginsScript = lib.optionalString (cfg.plugins != [ ]) (
        cfg.plugins
        |> map (p: p.pname)
        |> map (name: "exec-once = hyprctl plugin load \"${hyprPluginsJoin}/lib/lib${name}.so\"")
        |> lib.concatStringsSep "\n"
      );

      monitors = cfg.monitors;
      hasMultipleMonitors = lib.length monitors > 1;
      mainDisplay = lib.optionalString (monitors != [ ]) (
        monitors |> lib.filter (m: m.main) |> lib.head |> (m: m.name)
      );
      # first non-main display
      secondDisplay = lib.optionalString hasMultipleMonitors (
        monitors |> lib.filter (m: !m.main) |> lib.head |> (m: m.name)
      );
      workspaceAssignment = lib.optionalString hasMultipleMonitors (
        "\n"
        + (
          (lib.range 1 10)
          |> lib.map (n: "workspace = ${toString n}, monitor:${mainDisplay}")
          |> lib.concatStringsSep "\n"
        )
      );
    in
    lib.mkIf cfg.enable (
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
          # file to be sourced in hyprland.conf
          environment.etc."hypr/monitors.hypr".text =
            (lib.optionalString (cfg.monitors != [ ]) (
              cfg.monitors
              |> lib.map (opts: with opts; "monitor=${name},${res},${pos},${scaling}")
              |> lib.concatStringsSep "\n"
            ))
            + workspaceAssignment;

          environment.etc."hypr/extra.hypr".text = ''
            ${loadPluginsScript}
            ${cfg.extraConfig}
          '';

          environment.sessionVariables = {
            MAIN_DISPLAY = mainDisplay;
            MAIN_DISPLAY_ROFI = "'${mainDisplay}'"; # rofi needs extra quotes to deal with env variables
            SECOND_DISPLAY = if hasMultipleMonitors then secondDisplay else mainDisplay;
          }; # setting this here so i can manage autostart apps that are to open on the second display (if applies)

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
          systemd.user.services.hypridle.path = [ pkgs.playerctl ];
        }
        (lib.mkIf cfg.autoStartup {
          environment.loginShellInit =
            # bash
            ''
              if uwsm check may-start; then
              exec uwsm start hyprland-uwsm.desktop
              fi
            '';
        })
      ]
    );
}
