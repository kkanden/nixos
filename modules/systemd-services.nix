{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption;
  cfg = config.oliwia.systemdServices;
  mkServiceEnable = desc: (mkEnableOption desc) // { default = cfg.enable; };
in
{
  options.oliwia.systemdServices = {
    enable = mkEnableOption "my systemd services";
    services = {
      lock-before-suspend.enable = mkServiceEnable "lock before suspend service";
    };

  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      (lib.mkIf cfg.services.lock-before-suspend.enable {
        systemd.services.lock-before-suspend =
          let
            lockScript = pkgs.writeShellScript "lock-before-suspend" ''
              echo "lock-before-suspend.service: Attempting to lock sessions before suspension..."
              if ${pkgs.systemd}/bin/loginctl lock-sessions; then
                echo "lock-before-suspend.service: Successfully locked sessions."
              else
                echo "lock-before-suspend.service: Failed to lock sessions." >&2
                exit 1
              fi
            '';
          in
          {
            enable = cfg.services.lock-before-suspend.enable;
            description = "Lock sessions before suspending it.";
            before = [ "suspend.target" ];
            wantedBy = [ "suspend.target" ];
            serviceConfig = {
              Type = "oneshot";
              ExecStart = "${lockScript}";
            };
          };

      })
    ]
  );
}
