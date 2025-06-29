{
  inputs,
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
      wtype
      xdg-utils
      xdotool
      qimgv
      vlc
      gimp3-with-plugins
      ;

    inherit (pkgs.kdePackages)
      dolphin
      ;

    zen = inputs.zen-browser.packages.${pkgs.system}.default;
  };
}
