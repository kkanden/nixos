{
  config,
  lib,
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    hyprpolkitagent
    hyprpicker
    hyprshot
    grim
    slurp
    libnotify
    kitty
  ];

  programs.hyprland = {
    enable = true;
    # required for screen sharing to work
    xwayland.enable = true;
    withUWSM = true;
  };

}
