{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    hyprpolkitagent
    hyprpicker
    hyprshot
    hyprnotify
    hyprpaper
    hypridle
    hyprsysteminfo
    hyprland-qt-support
    hyprland-qtutils
    hyprcursor
    rose-pine-hyprcursor

    grim
    slurp
    libnotify
  ];

  programs.hyprland = {
    enable = true;
    # required for screen sharing to work
    xwayland.enable = true;
    withUWSM = true;
  };

}
