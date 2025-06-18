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
      cava
      cliphist
      discord-ptb
      firefox
      inotify-tools
      killall
      libnotify
      libqalculate
      libratbag
      libreoffice-qt6-fresh
      papirus-icon-theme
      piper
      playerctl
      pulseaudio
      qpwgraph
      spotify
      thunderbird-latest-unwrapped
      wl-clipboard
      xdg-utils
      xdotool
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
