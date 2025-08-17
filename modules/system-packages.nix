{
  inputs,
  pkgs,
  ...
}:
{
  environment.systemPackages = builtins.attrValues {
    inherit (pkgs)
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
      gnumake
      jq
      killall
      nix-prefetch-git
      pandoc
      postgresql_17
      texliveFull
      tree
      tree-sitter
      unzip
      unrar
      wget
      which
      yarn

      # cosmetic
      cava
      cowsay
      fortune
      lolcat

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
      cheese
      cliphist
      discord-ptb
      easyeffects
      firefox
      gimp3-with-plugins
      hardinfo2
      inotify-tools
      libnotify
      libqalculate
      libratbag
      libreoffice-qt6-fresh
      nautilus
      papirus-icon-theme
      pavucontrol
      piper
      playerctl
      pulseaudio
      qimgv
      qpwgraph
      sioyek
      spotify
      uxplay
      vlc
      wl-clipboard
      wtype
      xdg-utils
      xdotool

      #other
      rustlings
      ;

    inherit (pkgs.stable.nodePackages)
      prettier
      ;

    zen = inputs.zen-browser.packages.${pkgs.system}.default;
  };
  programs.thunderbird.enable = true;
  programs.kdeconnect.enable = true;
}
