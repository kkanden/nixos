{
  config,
  pkgs,
  lib,
  ...
}:
let
  user = "git";
  group = user;
in
{
  environment.etc."cgitrc".text = ''
    root-title=kanden's git
    root-desc=personal projects/configurations
    readme=:README.md
    enable-git-config=1
    enable-log-filecount=1
    enable-log-linecount=1

    css=/cgit-static/cgit.css
    about-filter=${pkgs.cgit}/lib/cgit/filters/about-formatting.sh
    max-stats=year
    default-page=tree

    clone-url=https://git.kanden.me/$CGIT_REPO_URL
    snapshots=tar.gz zip

    scan-path=/srv/git
    enable-http-clone=1
    remove-suffix=1
    virtual-root=/
  '';

  environment.etc."cgit-static/cgit.css".source = ../config/cgit/cgit.css;

  users.users.${user} = {
    isSystemUser = true;
    group = user;
    home = "/srv/git";
    shell = "${pkgs.git}/bin/git-shell";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG+HHjsMUyUNJixLglUag0FwhzD27uWLkbnjI5Vb3trJ oliwia@t450"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMkzHXRPuu3kXuvcYYq7y5WcckJTZpjptuGI+2MV00/ oliwia@desktop"
    ];
  };
  users.groups.${group} = { };
  users.users.caddy.extraGroups = [ group ];
  systemd.tmpfiles.rules = [
    "d /srv/git 0755 ${user} ${group} -"
  ]
  ++ (lib.optional config.systemd.services.cgit-backup.enable "d /var/backups/cgit 0755 ${user} ${group} -");

  systemd.services.cgit-backup = {
    description = "Backup cgit";
    path = [
      pkgs.gnutar
      pkgs.gzip
    ];
    serviceConfig = {
      User = user;
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "cgit-backup" ''
        TIMESTAMP=$(date +%Y%m%dT%H%M%S)
        cd /srv && tar zvcf "/var/backups/cgit/cgit-$TIMESTAMP.tar.gz" git/
      '';
    };
  };
  systemd.timers.cgit-backup = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "1:00:00";
      Persistent = true;
    };
  };
}
