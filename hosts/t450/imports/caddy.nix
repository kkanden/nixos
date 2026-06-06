{
  config,
  pkgs,
  inputs,
  ...
}:
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
        # managed through netbird
        "http://www.kanden.me" = {
          extraConfig = ''
            root * ${inputs.kanden-website.packages.${pkgs.stdenv.system}.default}
            file_server
          '';
        };
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
