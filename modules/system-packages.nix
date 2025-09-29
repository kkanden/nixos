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
      rustup
      typst

      # lsp
      basedpyright
      bash-language-server
      fish-lsp
      hyprls
      ltex-ls
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
      discord-ptb
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

  # my scripts with their dependencies
  oliwia.scripts = {
    definitions = {
      focus-or-launch = [
        pkgs.hyprland
        pkgs.jq
      ];
      killactive-steamsafe = [
        pkgs.hyprland
        pkgs.stable.xdotool
      ];
      rofi-open-filetype = [
        pkgs.rofi
        pkgs.stable.coreutils
        pkgs.stable.fd
        pkgs.stable.findutils
        pkgs.stable.xdg-utils
      ];
      rofi-tr = [
        pkgs.rofi
        pkgs.stable.translate-shell
        pkgs.stable.wl-clipboard
        pkgs.stable.libnotify
        pkgs.stable.mpv
      ];
      tmux-sessionizer = [
        pkgs.stable.tmux
        pkgs.stable.coreutils
        pkgs.stable.fd
        pkgs.stable.fzf
        pkgs.stable.gnused
        pkgs.stable.procps
      ];
    };
  };

  environment.sessionVariables = {
    TMUX_PLUGINS_CMD = lib.pipe tmux-plugins [
      (builtins.map (x: "tmux run-shell ${x.rtp}"))
      (builtins.concatStringsSep "\n")
    ];
  };
}
