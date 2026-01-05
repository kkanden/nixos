{
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./_hardware-configuration.nix
  ];

  boot.kernelPackages = lib.mkForce pkgs.linuxPackages;

  oliwia = {
    packages.extra.enable = true;
    hyprland = {
      enable = true;
      extraConfig = /* hyprlang */ ''
        debug {
          disable_scale_checks = true
        }
        input {
          sensitivity = 0
          touchpad {
            natural_scroll = true
            drag_lock = true
            scroll_factor = 0.7
          }
        }
      '';
      monitors = [
        {
          name = "eDP-1";
          scaling = "0.85";
          main = true;
        }
      ];
    };
    xdgPortal.enable = true;
    systemdServices = {
      enable = true;
    };
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
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  hardware.enableAllFirmware = true;

  services.logind.settings.Login = {
    HandleLidSwitch = "ignore";
  };

  # makes terminal apps work when opened as xdg default (eg neovim)
  xdg.terminal-exec = {
    enable = true;
    settings = {
      default = [ "Alacritty.desktop" ];
    };
  };

  environment.sessionVariables = {
    EDITOR = "nvim";
    BROWSER = "zen";
    TERMINAL = "alacritty";
  };

  # DON'T CHANGE!
  system.stateVersion = "26.05";
}
