{
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
  ]
  ++ lib.filesystem.listFilesRecursive ./modules;

  oliwia = {
    fishInteractiveShell.enable = true;
    fonts.enable = true;
    gpu.amd.enable = true;
    hyprland.enable = true;
    steam.enable = true;
    xdgPortal.enable = true;
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      7100
      7000
      7001
    ];
    allowedUDPPorts = [
      7011
      6000
      6001
    ];
  };

  services.getty.autologinUser = "oliwia"; # autologin
  services.openssh.enable = true;
  services.gvfs.enable = true; # trashcan
  services.pipewire = {
    enable = true;
    wireplumber.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    audio.enable = true;
    jack.enable = true;
  };
  services.avahi = {
    enable = true;
    publish = {
      enable = true;
      addresses = true;
      workstation = true;
      userServices = true;
    };
  };

  time.timeZone = "Europe/Warsaw";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFIUSTION = "en_CA.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  security.rtkit.enable = true;
  security.polkit.enable = true;

  hardware.enableAllFirmware = true;
  hardware.logitech.wireless.enable = true;

  users.users.oliwia = {
    isNormalUser = true;
    description = "oliwia";
    extraGroups = [
      "networkmanager"
      "wheel"
      "audio"
      "video"
      "input"
      "wireshark"
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nix = {
    settings.experimental-features = [
      "nix-command"
      "flakes"
      "pipe-operators"
    ];
  };

  # DON'T CHANGE!
  system.stateVersion = "25.05";
}
