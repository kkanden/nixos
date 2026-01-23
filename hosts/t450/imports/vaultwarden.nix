{ config, ... }:
{
  services.vaultwarden = {
    enable = true;
    backupDir = "/var/backups/vaultwarden";
    config = {
      ROCKET_ADDRESS = "0.0.0.0";
      ROCKET_PORT = 8222;
      ROCKET_LOG = "critical";
    };
  };
  networking.firewall.allowedTCPPorts = [ config.services.vaultwarden.config.ROCKET_PORT ];
}
