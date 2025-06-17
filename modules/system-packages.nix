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
      killall
      inotify-tools
      wl-clipboard
      libqalculate
      cliphist
      firefox
      discord-ptb
      spotify
      thunderbird-latest-unwrapped
      cava
      playerctl
      pulseaudio
      libnotify
      qpwgraph
      libratbag
      piper

      papirus-icon-theme

      libreoffice-qt6-fresh
      ;

    inherit (pkgs.kdePackages)
      dolphin
      gwenview
      ;

    zen = inputs.zen-browser.packages.${pkgs.system}.default;
  };
  services.ratbagd = {
    enable = true;
  };
}
