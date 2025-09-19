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
    with pkgs;
    [
      # basic tools
      bat
      diffutils
      dust
      fastfetch
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
      man-pages
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
      wget
      which
      yarn
      zip

      # cosmetic
      cava
      cowsay
      fortune
      lolcat
      stable.oh-my-posh

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

      # desktop
      alacritty
      cheese
      cliphist
      discord-ptb
      easyeffects
      firefox
      gimp3-with-plugins
      groff
      hardinfo2
      hyprpanel
      imagemagick
      inotify-tools
      libnotify
      libqalculate
      libratbag
      libreoffice-qt6-fresh
      lm_sensors
      mpv
      nautilus
      papirus-icon-theme
      pavucontrol
      piper
      playerctl
      pulseaudio
      qimgv
      qpwgraph
      (rofi.override { plugins = with pkgs; [ rofi-calc ]; })
      rofi-power-menu
      sioyek
      spotify
      translate-shell
      uxplay
      vlc
      wl-clipboard
      wtype
      xdg-utils
      xdotool
      yt-dlp

      #other
      rustlings

      stable.nodePackages.prettier
    ]
    ++ tmux-plugins
    ++ [
      inputs.zen-browser.packages.${pkgs.system}.default
    ];
  programs.thunderbird.enable = true;
  programs.kdeconnect.enable = true;

  environment.sessionVariables = {
    TMUX_PLUGINS_CMD = lib.pipe tmux-plugins [
      (builtins.map (x: "tmux run-shell ${x.rtp}"))
      (builtins.concatStringsSep "\n")
    ];
  };
}
