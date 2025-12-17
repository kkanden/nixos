{
  ...
}:
{
  imports = [
    ./_hardware-configuration.nix
  ];

  oliwia = {
    packages.extra.enable = true;
    gpu.amd.enable = true;
    hyprland = {
      enable = true;
      monitors = [
        {
          name = "DP-2";
          res = "highres";
          main = true;
        }
        {
          name = "HDMI-A-1";
          pos = "auto-left";
        }
      ];
    };
    steam.enable = true;
    xdgPortal.enable = true;
    virtualization.enable = true;
    systemdServices = {
      enable = true;
    };
  };

  networking.firewall = {
    # for uxplay
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

  services.avahi = {
    enable = true;
    publish = {
      enable = true;
      addresses = true;
      workstation = true;
      userServices = true;
    };
  };
  services.ratbagd.enable = true;
  services.playerctld.enable = true;

  hardware.enableAllFirmware = true;
  hardware.logitech.wireless.enable = true;
  # disable logitech mouse from waking up from `systemctl suspend`
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="usb", DRIVER=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c539", ATTR{power/wakeup}="disabled"
  '';

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
  system.stateVersion = "25.05";
}
