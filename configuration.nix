{
  pkgs,
  inputs,
  lib,
  ...
}:
let
  mk = lib.mkDefault;
in
{
  # oliwia defaults ----
  oliwia = {
    fish = {
      enable = mk true;
      stable = mk true;
    };
    fonts.enable = mk true;
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
  boot.loader.systemd-boot.enable = mk true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = mk true; # UEFI boot

  # networking
  networking.networkmanager = {
    enable = mk true;
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
  systemd.targets.network-online.wantedBy = mk [ ];

  # services ----
  services.openssh = {
    enable = mk true;
    settings = {
      PubkeyAuthentication = true;
      PasswordAuthentication = false;
    };
  };
  services.gvfs.enable = mk true; # trashcan
  services.pipewire = {
    enable = mk true;
    wireplumber.enable = mk true;
    alsa.enable = mk true;
    alsa.support32Bit = mk true;
    pulse.enable = mk true;
    jack.enable = mk true;
  };
  security.rtkit.enable = mk true; # for pipewire
  services.playerctld.enable = mk true;

  # nix ----
  nix = {
    settings = {
      experimental-features = mk [
        "nix-command"
        "flakes"
        "pipe-operator"
      ];
      warn-dirty = mk false;
    };
    nixPath = mk (builtins.map (x: "${x}=${inputs.${x}}") (builtins.attrNames inputs));
  };
  nixpkgs.config.allowUnfree = mk true;

  # misc ----
  time.timeZone = mk "Europe/Warsaw";

  i18n.defaultLocale = mk "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = mk "en_US.UTF-8";
    LC_IDENTIFIUSTION = mk "en_CA.UTF-8";
    LC_MEASUREMENT = mk "en_US.UTF-8";
    LC_MONETARY = mk "en_US.UTF-8";
    LC_NAME = mk "en_US.UTF-8";
    LC_NUMERIC = mk "en_US.UTF-8";
    LC_PAPER = mk "en_US.UTF-8";
    LC_TELEPHONE = mk "en_US.UTF-8";
    LC_TIME = mk "en_GB.UTF-8";
  };
}
