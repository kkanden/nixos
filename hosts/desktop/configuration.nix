{
  pkgs,
  lib,
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
      extraPackages = with pkgs; [
        (scrcpy.overrideAttrs (prev: {
          postInstall = prev.postInstall + ''
            wrapProgram $out/bin/scrcpy --set SDL_VIDEODRIVER x11 --add-flags "--render-driver=opengl"
          '';
        }))
        texliveFull
        prismlauncher
        piper
        rustlings
        libratbag
      ];
    };
    gpu.amd.enable = true;
    gpu.amd.overdrive = true;
    hyprland = {
      enable = true;
      autoStartup = true;
      plugins = with pkgs.hyprlandPlugins; [
        csgo-vulkan-fix
      ];
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
      extraConfig = /* hyprlang */ ''
        plugin {
            csgo-vulkan-fix {
                res_w = 1680
                res_h = 1050
                class = cs2
                fix_mouse = true
            }
        }
      '';
    };
    steam.enable = true;
    immich.machine-learning.enable = true;
    xdgPortal.enable = true;
    virtualization.enable = true;
    systemdServices = {
      enable = true;
    };
  };

  services.getty.autologinUser = "oliwia"; # autologin
  services.ratbagd.enable = true;
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
