{
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./_hardware-configuration.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  oliwia = {
    packages.extra = {
      enable = true;
      extraPackages = with pkgs; [ bluetui ];
    };
    hyprland = {
      enable = true;
      extraConfig = /* lua */ ''
        hl.config({
          debug = {
            disable_scale_checks = true
          },
          input = {
            sensitivity = 0.2,
            touchpad =  {
              natural_scroll = true,
              drag_lock = true,
              scroll_factor = 0.7,
            }
          }
        })
      '';
      monitors = [
        {
          name = "eDP-1";
          main = true;
        }
      ];
    };
    theme.enable = true;
  };

  services.playerctld.enable = true;
  services.qbittorrent.enable = true;
  services.mullvad-vpn.enable = true;
  systemd.services.qbittorrent =
    let
      vpn-device = "sys-devices-virtual-net-wg0\\x2dmullvad.device";
    in
    {
      after = lib.mkAfter [ vpn-device ];
      bindsTo = lib.mkAfter [ vpn-device ];
      upheldBy = lib.mkAfter [ vpn-device ];
      wantedBy = lib.mkForce [ ];
    };
  services.upower.enable = true;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };

  hardware.enableAllFirmware = true;

  # DON'T CHANGE!
  system.stateVersion = "26.11";
}
