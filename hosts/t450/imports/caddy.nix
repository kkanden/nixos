{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
let
  stripLocalhost = lib.strings.removePrefix "http://localhost:";
  anubisPorts =
    config.services.anubis.instances
    |> builtins.mapAttrs (name: value: stripLocalhost value.settings.TARGET);
  toAnubisPort = port: toString ((lib.strings.toInt port) + 1);
in
{
  services.caddy = {
    enable = true;
    package = (
      (pkgs.caddy.withPlugins {
        plugins = [
          "github.com/caddy-dns/desec@v1.1.0"
          "github.com/aksdb/caddy-cgi@v2.2.7"
        ];
        hash = "sha256-spadbybxXSXkLrcVHvMahGrNHfkAwMv77MNmrea4SSQ=";
      }).overrideAttrs
        { doInstallCheck = false; }
    );
    environmentFile = config.sops.secrets.caddy-env.path;
    globalConfig = ''
      email {env.EMAIL}
      order cgi before respond
    '';
    virtualHosts =
      let
        tls_default = ''
          tls {
            dns desec {
              token "{env.DESEC_TOKEN}"
            }
            propagation_delay 30s
          }
        '';
      in
      {
        # external listeners (anubis proxy)
        "http://www.kanden.me" = {
          extraConfig = ''
            reverse_proxy localhost:${toAnubisPort anubisPorts.www}
          '';
        };
        "http://git.kanden.me" = {
          extraConfig =
            # we handle git clones directly without the anubis proxy
            ''
              @gitclone path_regexp ^/.*/(info/refs|git-upload-pack)$
              handle @gitclone {
                cgi * ${pkgs.git}/libexec/git-core/git-http-backend {
                  env GIT_PROJECT_ROOT=/srv/git GIT_HTTP_EXPORT_ALL=1
                }
              }
              handle {
                reverse_proxy localhost:${toAnubisPort anubisPorts.git}
              }
            '';
        };
        "http://immich-share.kanden.me" = {
          extraConfig = ''
            reverse_proxy localhost:${toAnubisPort anubisPorts.git}
          '';
        };

        # internal listeners (anubis proxy)
        "http://:${anubisPorts.www}" = {
          extraConfig = ''
            root * ${inputs.kanden-website.packages.${pkgs.stdenv.system}.default}
            file_server
          '';
        };
        "http://:${anubisPorts.git}" = {
          extraConfig = ''
            @static path /cgit.css /cgit.js /cgit.png /favicon.ico /robots.txt
            handle @static {
              root * ${pkgs.cgit}/cgit
              file_server
            }
            handle {
              cgi * ${pkgs.cgit}/cgit/cgit.cgi {
                env CGIT_CONFIG=/etc/cgitrc
              }
            }
          '';
        };
        "http://localhost:${anubisPorts.immich-share}" = {
          extraConfig =
            let
              url = "localhost:${toString config.services.immich.port}";
            in
            ''
              # allow all get requests, they're read-only
              @get {
                  method GET
              }
              handle @get {
                  reverse_proxy ${url}
              }

              # allow upload only if it's a shared album
              @upload {
                method POST
                path /api/assets* /api/download*
              }
              handle @upload {
                reverse_proxy ${url}
              }

              # otherwise reject
              handle {
                respond 403
              }
            '';
        };

        # private services accessible only within my netbird network
        "vaultwarden.kanden.me" = {
          extraConfig = ''
            reverse_proxy localhost:${toString config.services.vaultwarden.config.ROCKET_PORT}
            ${tls_default}
          '';
        };
        "immich.kanden.me" = {
          extraConfig = ''
            reverse_proxy localhost:${toString config.services.immich.port}
            ${tls_default}
          '';
        };
      };
  };
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
  sops.secrets = {
    caddy-env = {
      owner = config.users.users.caddy.name;
      group = config.users.users.caddy.group;
      restartUnits = [ "caddy.service" ];
    };
  };
}
