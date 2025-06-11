{
  config,
  lib,
  pkgs,
  ...
}:
{
  # enable OpenGL
  hardware.graphics = {
    enable = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    open = true;
    nvidiaSettings = true;
    modesetting.enable = true;

    powerManagement = {
      enable = false;
      finegrained = false;
    };
  };

}
