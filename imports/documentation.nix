{
  pkgs,
  config,
  lib,
  ...
}:
{

  # this regenerates the cache on almost all rebuilds and it's very slow
  # we do it on our own which also skips the regeneration when it's not necessary
  documentation.man.generateCaches = lib.mkForce false;

  # based on https://github.com/MidAutumnMoon/TaysiTsuki/blob/8356198dc5106278dad747dae4cf407fd9d93956/nixos/documentation/module.nix
  systemd.services."man-db" =
    let
      cfg = config.documentation.man.man-db;
      cachePath = "/var/cache/man/nixos";
    in
    {
      requires = [ "sysinit-reactivation.target" ];
      after = [ "sysinit-reactivation.target" ];
      partOf = [ "sysinit-reactivation.target" ];
      wantedBy = [ "default.target" ];
      path = [ cfg.package ];

      # Upstream config
      serviceConfig = {
        Nice = 19;
        IOSchedulingClass = "idle";
        IOSchedulingPriority = 7;
      };

      serviceConfig.ExecStart = pkgs.writeShellScript "man-db-rebuild" ''
        set -e
        currentMan="/run/current-system/sw/share/man"
        oldManHash="${cachePath}/man-db-state"

        if [[ ! -d "${cachePath}" ]]; then
        	mkdir -pv "${cachePath}"
        fi

        if [[ ! -f "$oldManHash" ]]; then
        	touch "$oldManHash"
        fi

        # collect hashes, sort, join and hash again
        hashes=
        while read -r line; do
            hash="''${line%% *}" # keep up to first space
            hashes+="$hash"$'\n' # join with newline
        done <<< $(find -L "$currentMan" -type f -iname "*.gz" -exec sha256sum "{}" "+")

        hashes="$(echo $hashes | sort)"
        hashes="''${hashes//$'\n'/}" # concat lines

        ultimate_hash="$(echo -n "$hashes" | sha256sum -)"
        ultimate_hash="''${ultimate_hash%% *}"

        old_hash="$(cat "$oldManHash")"

        echo "Old hash: $old_hash"
        echo "New hash: $ultimate_hash"

        if [[ "$old_hash" != "$ultimate_hash" ]]; then
            echo "Hash changed, doing a full man-db rebuild"
            mandb -psc
            echo "Writing new hash: $ultimate_hash"
            echo "$ultimate_hash" > "$oldManHash"
        else
            echo "Hash not changed, skipping"
        fi
      '';
    };

  environment.extraSetup = /* bash */ ''
    find "$out/share/man" \
        -mindepth 1 -maxdepth 1 \
        -not -name "man[1-8]" \
        -exec rm -r "{}" ";"
  '';

}
