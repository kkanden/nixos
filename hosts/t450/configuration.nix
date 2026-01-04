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
    };
    xdgPortal.enable = true;
    virtualization.enable = true;
    systemdServices = {
      enable = true;
    };
  };

  services.playerctld.enable = true;
  services.lact.enable = true;
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

  hardware.enableAllFirmware = true;

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
