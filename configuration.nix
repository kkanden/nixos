{
  pkgs,
  inputs,
  ...
}:
{
  # oliwia defaults ----
  oliwia = {
    fish = {
      enable = true;
      stable = true;
    };
    fonts.enable = true;
    xdgPortal.enable = true;
    virtualization.enable = true;
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
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true; # UEFI boot
  boot.kernelPackages = pkgs.linuxPackages_zen;

  # networking ----
  networking.networkmanager.enable = true;

  # services ----
  services.getty.autologinUser = "oliwia"; # autologin
  services.openssh.enable = true;
  services.gvfs.enable = true; # trashcan
  services.pipewire = {
    enable = true;
    wireplumber.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
  security.rtkit.enable = true; # for pipewire
  services.playerctld.enable = true;

  # nix ----
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
        "pipe-operators"
      ];
      warn-dirty = false;
    };
    nixPath = builtins.map (x: "${x}=${inputs.${x}}") (builtins.attrNames inputs);
  };
  nixpkgs.config.allowUnfree = true;

  # misc ----
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
}
