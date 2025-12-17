{
  pkgs,
  inputs,
  lib,
  ...
}:
{
  # oliwia defaults ----
  oliwia = {
    fish = {
      enable = lib.mkDefault true;
      stable = lib.mkDefault true;
    };
    fonts.enable = lib.mkDefault true;
    xdgPortal.enable = lib.mkDefault true;
  };

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

  # boot ----
  boot.loader.systemd-boot.enable = lib.mkDefault true;
  boot.loader.efi.canTouchEfiVariables = lib.mkDefault true; # UEFI boot
  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_zen;

  # networking ----
  networking.networkmanager.enable = lib.mkDefault true;

  # services ----
  services.getty.autologinUser = lib.mkDefault "oliwia"; # autologin
  services.openssh.enable = lib.mkDefault true;
  services.gvfs.enable = lib.mkDefault true; # trashcan
  services.pipewire = {
    enable = lib.mkDefault true;
    wireplumber.enable = lib.mkDefault true;
    alsa.enable = lib.mkDefault true;
    alsa.support32Bit = lib.mkDefault true;
    pulse.enable = lib.mkDefault true;
    jack.enable = lib.mkDefault true;
  };
  security.rtkit.enable = lib.mkDefault true; # for pipewire
  services.playerctld.enable = lib.mkDefault true;

  # nix ----
  nix = {
    settings = {
      experimental-features = lib.mkDefault [
        "nix-command"
        "flakes"
        "pipe-operators"
      ];
      warn-dirty = lib.mkDefault false;
    };
    nixPath = lib.mkDefault (builtins.map (x: "${x}=${inputs.${x}}") (builtins.attrNames inputs));
  };
  nixpkgs.config.allowUnfree = lib.mkDefault true;

  # misc ----
  time.timeZone = lib.mkDefault "Europe/Warsaw";

  i18n.defaultLocale = lib.mkDefault "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = lib.mkDefault "en_US.UTF-8";
    LC_IDENTIFIUSTION = lib.mkDefault "en_CA.UTF-8";
    LC_MEASUREMENT = lib.mkDefault "en_US.UTF-8";
    LC_MONETARY = lib.mkDefault "en_US.UTF-8";
    LC_NAME = lib.mkDefault "en_US.UTF-8";
    LC_NUMERIC = lib.mkDefault "en_US.UTF-8";
    LC_PAPER = lib.mkDefault "en_US.UTF-8";
    LC_TELEPHONE = lib.mkDefault "en_US.UTF-8";
    LC_TIME = lib.mkDefault "en_GB.UTF-8";
  };
}
