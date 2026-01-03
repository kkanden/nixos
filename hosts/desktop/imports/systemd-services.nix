{ pkgs, ... }:
{
  systemd.services.home-backup =
    let
      script = pkgs.writeShellScript "sync" ''
        ${pkgs.rsync}/bin/rsync -ah --delete --exclude-from=/etc/nixos/config/rsync-exclude /home/oliwia/ /mnt/hdd/home
      '';
    in
    {
      description = "Backup /home/oliwia to /mnt/hdd/home";
      after = [
        "mnt-hdd.mount"
        "multi-user.target"
      ];
      requires = [ "mnt-hdd.mount" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${script}";
        StandardOutput = "journal";
        StandardError = "journal";
        PrivateTmp = true;
        NoNewPrivileges = true;
      };
    };
  systemd.timers.home-backup = {
    description = "Daily backup of /home/oliwia";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "5min";
      OnCalendar = "daily";
      Persistent = true;
      RandomizedDelaySec = "30min";
    };
  };
}
