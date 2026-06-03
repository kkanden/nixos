{ config, pkgs, ... }:
{
  services.caddy = {
    enable = true;
    package = pkgs.caddy.withPlugins {
      plugins = [
        "github.com/caddy-dns/desec@v1.1.0"
      ];
      hash = "sha256-xHmhjCrAaqbnYLAxXCsZ8ah6umgwHWQIXWqeDbghCOo=";
    };
    environmentFile = "/run/secrets/caddy-env";
    globalConfig = ''
      email {env.EMAIL}
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
}
