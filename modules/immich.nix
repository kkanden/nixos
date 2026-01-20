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
  backupDir = cfg.backup.backupDir;
  user = config.services.immich.database.user;
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
    backup = {
      backupDir = mkOption {
        description = "Backup directory";
        type = types.str;
        default = "/var/backups/immich";
      };
      db = {
        enable = mkEnableOption "Immich daily backup service";
        deleteOlderThan = mkOption {
          description = "Delete backups older than X days";
          type = types.str;
          default = "14";
        };
      };
      assets.enable = mkEnableOption "Backup assets";
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
      users.users.immich = {
        home = lib.mkForce "/var/lib/immich";
        createHome = lib.mkForce true;
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

    (lib.mkIf cfg.backup.db.enable {
      systemd.tmpfiles.rules = [
        "d ${backupDir} 0755 ${user} root - -"
        "d ${backupDir}/db 0755 ${user} root - -"
      ]
      ++ (lib.optional cfg.backup.assets.enable "d ${backupDir}/assets 0755 ${user} root - -");

      systemd.services.immich-backup =
        let
          uploadLocation = config.services.immich.mediaLocation;
          dbname = config.services.immich.database.name;
          dbDeleteOlderThan = cfg.backup.db.deleteOlderThan;
        in
        {
          description = "Immich database backup";
          path = with pkgs.stable; [
            postgresql
            gzip
            gnutar
            findutils
            rsync
          ];
          # turn off server during backup
          # server is turned back on by immich-restart-after-backup
          conflicts = [ "immich-server.service" ];
          serviceConfig = {
            Type = "oneshot";
            User = user;
            ExecStart =
              let
                asset-script = lib.optionalString cfg.backup.assets.enable /* bash */ ''
                  BACKUP_ASSET_DIR="${backupDir}/assets"
                  LAST_TIMESTAMP=$(cat ${backupDir}/.last-backup 2>/dev/null || true)
                  LAST_BACKUP="$BACKUP_ASSET_DIR/immich-assets-$LAST_TIMESTAMP"

                  echo "Backing up assets..."

                  if [[ -d "$LAST_BACKUP" ]]; then
                    echo "Creating incremental backup..."
                    rsync -aAX --delete --link-dest="$LAST_BACKUP" ${uploadLocation}/ "$BACKUP_ASSET_DIR/immich-assets-$TIMESTAMP"
                  else
                    rsync -aAX --delete ${uploadLocation}/ "$BACKUP_ASSET_DIR/immich-assets-$TIMESTAMP"
                  fi
                  echo "Done!"
                '';
              in
              pkgs.writeShellScript "immich-backup" ''
                set -e

                TIMESTAMP=$(date +%Y%m%dT%H%M%S)
                BACKUP_DB_DIR="${backupDir}/db"

                echo "Backup directory: ${backupDir}"
                echo "Database: ${dbname}"
                echo "Upload location: ${uploadLocation}"

                echo "Backing up database..."

                pg_dump \
                --dbname ${dbname} \
                --username ${user} \
                --clean \
                --if-exists \
                | gzip > "$BACKUP_DB_DIR/immich_db-$TIMESTAMP.sql.gz"

                echo "Done!"

                echo "Removing database backups older than ${dbDeleteOlderThan} days..."
                echo "Done!"

                ${asset-script}

                find "${backupDir}" -name "immich_*" -mtime +${dbDeleteOlderThan} -delete

                echo "$TIMESTAMP" > "${backupDir}/.last-backup"
              '';
          };
        };

      systemd.services.immich-restart-after-backup = {
        description = "Restart Immich server after backup";
        after = [ "immich-backup.service" ];
        wantedBy = [ "immich-backup.service" ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${pkgs.systemd}/bin/systemctl start immich-server.service";
        };
      };

      systemd.timers.immich-backup = {
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnCalendar = "2:00:00";
          Persistent = true;
          Unit = "immich-backup.service";
        };
      };
    })
  ];
}
