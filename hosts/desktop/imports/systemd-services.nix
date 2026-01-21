{ pkgs, lib', ... }:
{
  systemd.services.home-backup = {
    description = "Home backup";
    after = [
      "mnt-hdd.mount"
      "multi-user.target"
    ];
    requires = [ "mnt-hdd.mount" ];
    serviceConfig = lib'.mkHardened {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "home-backup" ''
        ${pkgs.rsync}/bin/rsync -ah --delete --exclude-from=/etc/nixos/config/rsync-exclude /home/oliwia/ /mnt/hdd/home
      '';
    };
  };
  systemd.timers.home-backup = {
    description = "Home backup timer";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "5min";
      OnCalendar = "daily";
      Persistent = true;
      RandomizedDelaySec = "30min";
    };
  };

  systemd.services.immich-backup-sync = {
    description = "Sync immich backup";
    after = [
      "mnt-hdd.mount"
      "network-online.target"
    ];
    requires = [
      "mnt-hdd.mount"
      "network-online.target"
    ];
    path = with pkgs; [
      rsync
      openssh
      iputils
    ];
    serviceConfig = lib'.mkHardened {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "immich-backup-sync" ''
        if ! ping -c 1 -W 5 t450 &>/dev/null; then
          echo "Remote is not reachable. Exiting..."
          exit 1
        fi

        rsync -ahH --delete --info=stats root@t450:/var/backups/immich/ /mnt/hdd/immich
        chown -R oliwia:users /mnt/hdd/immich
      '';

      PrivateUsers = false; # /mnt/hdd/immich is owned by a regular user
    };
  };
  systemd.timers.immich-backup-sync = {
    description = "Sync immich backup timer";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "8:00:00";
      Persistent = true;
    };
  };
}
