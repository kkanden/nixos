{ pkgs, lib', ... }:
{
  services.ratbagd.enable = true;

  # automatic profile switcher
  systemd.user.services.ratbagd-profile-switcher = {
    description = "ratbagd-profile-switcher";
    wantedBy = [ "graphical-session.target" ];
    path = with pkgs; [
      bash
      hyprland
      jq
      gawk
      libratbag
      coreutils
    ];
    script = "bash ${lib'.mkScript "ratbagd-profile-switcher"}";
  };

  hardware.logitech.wireless.enable = true;
}
