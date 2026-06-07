{
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./_hardware-configuration.nix
  ]
  ++ lib.filesystem.listFilesRecursive ./imports;

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
            sensitivity = 0,
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
          scaling = "0.85";
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

  services.logind.settings.Login = {
    HandleLidSwitch = "ignore";
  };

  oliwia.immich = {
    server.enable = true;
    backup = {
      db.enable = true;
      assets.enable = true;
    };
  };

  # this is just so caddy+cgit stops complaining about dubious ownership
  # idk if this is bad practice but it makes it work
  environment.etc."gitconfig".text = /* gitconfig */ ''
    [init]
      defaultBranch = main
    [core]
      sharedRepository = all
    [safe]
      directory = *
  '';

  # makes terminal apps work when opened as xdg default (eg neovim)
  xdg.terminal-exec = {
    enable = true;
    settings = {
      default = [ "Alacritty.desktop" ];
    };
  };

  # DON'T CHANGE!
  system.stateVersion = "26.05";
}
