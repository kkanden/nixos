{
  pkgs,
  inputs,
  lib,
  config,
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
    dotfiles = {
      "fish/config.fish" = "fish/config.fish";
      "fish/theme.fish" = "fish/vague.fish";
      "oh-my-posh/config.toml" = "oh-my-posh/omp-vague.toml";
      alacritty = "alacritty";
      bat = "bat";
      clangd = "clangd";
      dust = "dust";
      fastfetch = "fastfetch";
      fzf = "fzf";
      git = "git";
      hypr = "hypr";
      qimgv = "qimgv";
      ripgrep = "ripgrep";
      rofi = "rofi";
      sioyek = "sioyek";
      tmux = "tmux";
      wayle = "wayle";
    };
  };
  environment = {
    sessionVariables."RIPGREP_CONFIG_PATH" = "$HOME/.config/ripgrep/ripgreprc";
    sessionVariables."FZF_DEFAULT_OPTS_FILE" = "$HOME/.config/fzf/config";

    # xdg ----
    sessionVariables = {
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_STATE_HOME = "$HOME/.local/state";

      BROWSER = "zen-beta";
      TERMINAL = "alacritty";
    };
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
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true; # UEFI boot

  # networking
  networking.networkmanager = {
    enable = true;
    wifi.powersave = false;
    dispatcherScripts = [
      {
        # if connected to ethernet, disable wifi
        source = pkgs.writeShellScript "toggleWifi" ''
          # $1 is device name, $2 is the action
          if [[ "$1" =~ en.*|eth.* ]]; then
              case "$2" in
                  up)
                      ${pkgs.networkmanager}/bin/nmcli radio wifi off
                      ;;
                  down)
                      ${pkgs.networkmanager}/bin/nmcli radio wifi on
                      ;;
              esac
          fi
        '';
        type = "basic";
      }
    ];
  };
  systemd.services.NetworkManager-wait-online.wantedBy = lib.mkForce [ ];
  systemd.targets.network-online.wantedBy = [ ];

  # services ----
  services.openssh = {
    enable = true;
    settings = {
      PubkeyAuthentication = true;
      PasswordAuthentication = false;
    };
  };
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
  services.resolved.enable = true;
  services.netbird.enable = true;
  networking.firewall.trustedInterfaces = [ "wt0" ];
  programs.gnupg.agent.enable = true;

  security = {
    polkit = {
      enable = true;
      extraConfig = /* javascript */ ''
        polkit.addRule(function (action, subject) {
          if (
            subject.isInGroup("users") &&
            [
              "org.freedesktop.login1.reboot",
              "org.freedesktop.login1.reboot-multiple-sessions",
              "org.freedesktop.login1.power-off",
              "org.freedesktop.login1.power-off-multiple-sessions",
            ].indexOf(action.id) !== -1
          ) {
            return polkit.Result.YES;
          }
        });
      '';
    };
  };
  sops = {
    defaultSopsFile = ./secrets.yaml;
    age = {
      keyFile = "/var/lib/sops-nix/key.txt";
      sshKeyPaths = [
        "/etc/ssh/ssh_host_ed25519_key"
        "/home/oliwia/.ssh/id_ed25519"
      ];
      generateKey = true;
    };
  };

  # nix ----
  nix = {
    settings = {
      trusted-users = [ "@wheel" ];
      experimental-features = [
        "nix-command"
        "flakes"
        "pipe-operator"
      ];
      warn-dirty = false;
    };
    nixPath = (builtins.map (x: "${x}=${inputs.${x}}") (builtins.attrNames inputs));
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
