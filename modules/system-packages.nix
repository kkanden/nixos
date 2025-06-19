{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
{
  environment.systemPackages = builtins.attrValues {
    inherit (pkgs)
      # basic tools
      bat
      cliphist
      diffutils
      dust
      fd
      ffmpeg
      fontconfig
      fzf
      gcc
      gh
      gnumake
      inotify-tools
      jq
      killall
      libnotify
      libqalculate
      nix-prefetch-git
      pandoc
      postgresql_17
      texliveFull
      tree
      tree-sitter
      unzip
      wget
      which
      wl-clipboard
      xdg-utils
      xdotool
      yarn
      # cosmetic
      cava
      cowsay
      fortune
      lolcat
      papirus-icon-theme
      # langs
      jdk
      nodejs_24
      perl
      php
      powershell
      rustup
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
      vscode-langservers-extracted
      yaml-language-server
      # formatters
      air-formatter
      alejandra
      nixfmt-rfc-style
      shfmt
      stylua
      tex-fmt

      # desktop programs
      discord-ptb
      firefox
      libratbag
      libreoffice-qt6-fresh
      piper
      playerctl
      pulseaudio
      qpwgraph
      spotify
      thunderbird-latest-unwrapped
      ;

    inherit (pkgs.kdePackages)
      dolphin
      gwenview
      ;

    inherit (pkgs.nodePackages)
      prettier
      ;

    zen = inputs.zen-browser.packages.${pkgs.system}.default;
  };
  services.ratbagd = {
    enable = true;
  };
}
