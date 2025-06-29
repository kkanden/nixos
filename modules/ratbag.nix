{ pkgs, lib', ... }:
{
  services.ratbagd.enable = true;

  # automatic profile switcher
  systemd.user.services.ratbagd-profile-switcher = {
    description = "Automatic mouse profile switcher for games";
    wantedBy = [ "default.target" ];
    path = with pkgs; [
      hyprland
      bash
      jq
      gawk
      libratbag
    ];
    script = "bash ${lib'.mkScript "ratbagd-profile-switcher"}";
    serviceConfig = {
      Restart = "always";
      RestartSec = 0;
    };
  };

  hardware.logitech.wireless.enable = true;
}
