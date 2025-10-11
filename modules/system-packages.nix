{
  inputs,
  pkgs,
  lib,
  ...
}:
let
  tmux-plugins = with pkgs.tmuxPlugins; [
    yank
  ];
in
{
  environment.systemPackages =
    (with pkgs.stable; [
      # basic tools
      bat
      diffutils
      dust
      fd
      ffmpeg
      fontconfig
      fzf
      gcc
      gh
      git
      gnumake
      jq
      killall
      man-pages # linux dev man pages
      nix-prefetch-git
      pandoc
      postgresql_17
      ripgrep
      texliveFull
      tmux
      tree
      tree-sitter
      unrar
      unzip
      websocat
      wget
      which
      yarn
      yt-dlp
      zip
      # cosmetic
      cowsay
      fortune
      lolcat
      oh-my-posh

      # desktop
      cheese
      cliphist
      groff # plain text to typeset
      inotify-tools
      libnotify
      libqalculate
      libreoffice-qt6-fresh
      mpv
      nautilus
      pinta
      qimgv
      translate-shell
      vlc
      wl-clipboard
      wtype
      xdg-utils
      xdotool
    ])
    ++ (with pkgs; [

      #basic tool
      fastfetch

      # cosmetic
      cava

      # langs
      jdk
      nodejs_24
      perl
      php
      powershell
      (python313.withPackages (
        p: with p; [
          black
          isort
        ]
      ))
      R
      rustup
      typst

      # lsp
      basedpyright
      bash-language-server
      fish-lsp
      hyprls
      lua-language-server
      marksman
      nil
      nixd
      taplo
      texlab
      tinymist
      vscode-langservers-extracted
      yaml-language-server

      # formatters
      air-formatter
      alejandra
      nixfmt-rfc-style
      shfmt
      stylua
      tex-fmt
      typstyle
      stable.nodePackages.prettier

      # desktop
      alacritty
      discord
      firefox
      gimp3-with-plugins
      hyprpanel
      papirus-icon-theme
      (rofi.override { plugins = with pkgs; [ rofi-calc ]; })
      rofi-power-menu
      sioyek
      spotify
      uxplay # apple airdrop server

      # hardware tools
      easyeffects
      hardinfo2
      imagemagick
      libratbag
      lm_sensors
      pavucontrol
      piper
      playerctl
      pulseaudio
      qpwgraph

      #other
      rustlings

    ])
    ++ tmux-plugins
    ++ [
      inputs.zen-browser.packages.${pkgs.system}.default
    ];
  programs.thunderbird.enable = true;
  programs.kdeconnect.enable = true;
  programs.nh = {
    enable = true;
    flake = "/etc/nixos";
  };
  programs.nix-index = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
  };
  programs.command-not-found.enable = false;
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
      obs-vkcapture
    ];
  };

  # my scripts with their dependencies
  oliwia.scripts = {
    scripts = {
      focus-or-launch = {
        dependencies = with pkgs; [
          hyprland
          stable.jq
        ];
      };
      killactive-steamsafe = {
        dependencies = with pkgs; [
          hyprland
          stable.xdotool
        ];
      };
      rofi-open-filetype = {
        dependencies = with pkgs; [
          rofi
          stable.coreutils
          stable.fd
          stable.findutils
          stable.xdg-utils
        ];
      };
      rofi-tr = {
        dependencies = with pkgs; [
          rofi
          stable.translate-shell
          stable.wl-clipboard
          stable.libnotify
          stable.mpv
        ];
      };
      rofi-clipboard = {
        dependencies = with pkgs; [
          rofi
          cliphist
          hyprland
          wl-clipboard
        ];
      };
      tmux-sessionizer = {
        dependencies = with pkgs.stable; [
          tmux
          coreutils
          fd
          fzf
          gnused
          procps
        ];
      };
      screenshot = {
        dependencies = with pkgs; [
          grim
          hyprpicker
          procps
          slurp
          wl-clipboard
        ];
      };
        ];
      };
    };
  };

  environment.sessionVariables = {
    TMUX_PLUGINS_CMD = lib.pipe tmux-plugins [
      (builtins.map (x: "tmux run-shell ${x.rtp}"))
      (builtins.concatStringsSep "\n")
    ];
  };
}
