{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.oliwia.immich;
  inherit (lib) mkOption mkEnableOption;
  inherit (lib) types;
in
{
  options.oliwia.immich = {
    server = {
      enable = mkEnableOption "Immich server";
      host = mkOption {
        description = "Immich server host";
        type = types.str;
        default = "0.0.0.0";
      };
    };
    machine-learning.enable = mkEnableOption "Immich machine learning service" // {
      default = cfg.server.enable;
    };
  };
  config = lib.mkMerge [

    (lib.mkIf cfg.server.enable {
      services.immich = {
        enable = true;
        host = cfg.server.host;
        openFirewall = true;
        machine-learning.enable = false; # i use my own service definition
      };
    })

    (lib.mkIf cfg.machine-learning.enable {
      networking.firewall.allowedTCPPorts = [ 3003 ];
      systemd.services.immich-ml = {
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        environment = {
          IMMICH_HOST = cfg.server.host;
          IMMICH_PORT = "3003";
          XDG_CACHE_HOME = "/var/cache/immich-ml";
          MACHINE_LEARNING_CACHE_FOLDER = "/var/cache/immich-ml";
          MACHINE_LEARNING_WORKERS = "1";
          MACHINE_LEARNING_WORKER_TIMEOUT = "120";
        };
        serviceConfig = {
          Type = "simple";
          Restart = "on-failure";
          RestartSec = 3;

          ExecStart = lib.getExe pkgs.immich-machine-learning;
          PrivateDevices = false;
          CacheDirectory = "immich-ml";
          User = "immich-ml";
          Group = "immich-ml";

          # Hardening
          DynamicUser = true;
          PrivateMounts = true;
          ProtectClock = true;
          ProtectControlGroups = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          RestrictAddressFamilies = [
            "AF_INET"
            "AF_INET6"
            "AF_UNIX"
          ];
          RestrictRealtime = true;
          UMask = "0077";
        };
      };
      users.users.immich-ml = {
        name = "immich-ml";
        group = "immich-ml";
        isSystemUser = true;
      };
      users.groups.immich-ml = { };
    })
  ];
}
