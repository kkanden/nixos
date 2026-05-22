{
  lib,
  repoPathStr,
  config,
  ...
}:
let
  inherit (lib) types;
  cfg = config.oliwia.dotfiles;

  home = "/home/oliwia";
  configDir = repoPathStr + "/config";
in
{
  options.oliwia.dotfiles = lib.mkOption {
    type = types.attrsOf types.str;
    example = lib.literalExpression ''
      {
          "dest/in/.config" = "src/in/repo/config";
      }
    '';
  };

  config = {
    system.activationScripts.dotfiles = {
      text = # bash
        ''
          set -e
          mk_link() {
              local link="${home}/$1"
              local src="$2"

              mkdir -p "$(dirname "$link")"
              if [[ -e "$link" ]] && [[ ! -L "$link" ]]; then
                  echo "dotfiles: $link exists and is not a symlink, skipping"
              else
                  ln -sfn "$src" "$link"
              fi
          }

          mk_config_link() {
              local dest="$1"
              local src="$2"
              local host_src="${repoPathStr}/hosts/${config.networking.hostName}/config/$src"
              local global_src="${configDir}/$src"
              local resolved_src
              local found=false

              for resolved_src in "$global_src" "$host_src"; do
                  [[ -e "$resolved_src" ]] || continue
                  local found=true
                  if [[ -d "$resolved_src" ]]; then
                      while IFS= read -r -d "" file; do
                          rel="''${file#"$resolved_src/"}"
                          mk_link ".config/$dest/$rel" "$file"
                      done < <(find "$resolved_src" -type f -print0)
                  elif [[ -f "$resolved_src" ]]; then
                      mk_link ".config/$dest" "$resolved_src"
                  fi
              done

              if ! $found; then
                  echo "dotfiles: $src not found, skipping"
              fi
          }

          echo -n "symlinking dotfiles... "
          ${
            (lib.concatStrings (
              lib.mapAttrsToList (dest: src: ''
                mk_config_link "${dest}" "${src}"
              '') cfg
            ))
          }
          echo "done"
        '';
      deps = [
        "users"
        "groups"
      ];
    };

  };
}
