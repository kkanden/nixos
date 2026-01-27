{ pkgs, lib', ... }:
{
  systemd.services.home-backup = {
    description = "Home Backup";
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
    description = "Home Backup timer";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "5min";
      OnCalendar = "daily";
      Persistent = true;
      RandomizedDelaySec = "30min";
    };
  };

  systemd.services.pull-backups = {
    description = "Pull Remote Backups";
    after = [
      "mnt-hdd.mount"
      "network-online.target"
      "nss-lookup.target"
      "NetworkManager-wait-online.service"
      "multi-user.target"
    ];
    wants = [
      "network-online.target"
      "nss-lookup.target"
      "multi-user.target"
    ];
    requires = [
      "mnt-hdd.mount"
    ];
    path = with pkgs; [
      rsync
      openssh
      iputils
    ];
    serviceConfig = lib'.mkHardened {
      Type = "oneshot";
      Restart = "on-failure";
      RestartSec = "10s";
      ExecStart = pkgs.writeShellScript "pull-backups" ''
        if ! ping -c 1 -W 5 t450 1>/dev/null; then
          echo "Remote is not reachable. Exiting..."
          exit 1
        fi

        rsync -ahH --delete --info=stats root@t450:/var/backups/ /mnt/hdd/backups
        chown -R oliwia:users /mnt/hdd/backups
      '';

      PrivateUsers = false; # /mnt/hdd/backups is owned by a regular user
    };
  };
  systemd.timers.pull-backups = {
    description = "Pull Remote Backups Timer";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "8:00:00";
      Persistent = true;
    };
  };
}
