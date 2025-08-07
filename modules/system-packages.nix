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
      pavucontrol
      cliphist
      discord-ptb
      firefox
      gimp3-with-plugins
      inotify-tools
      libnotify
      libqalculate
      libratbag
      libreoffice-qt6-fresh
      papirus-icon-theme
      piper
      playerctl
      pulseaudio
      qimgv
      qpwgraph
      spotify
      thunderbird-latest-unwrapped
      vlc
      wl-clipboard
      wtype
      xdg-utils
      xdotool
      nautilus
      hardinfo2
      easyeffects
      cheese

      #other
      rustlings
      ;

    inherit (pkgs.kdePackages)
      dolphin
      ;

    inherit (pkgs.stable.nodePackages)
      prettier
      ;

    zen = inputs.zen-browser.packages.${pkgs.system}.default;
  };
  programs.thunderbird.enable = true;
  programs.kdeconnect.enable = true;
}
