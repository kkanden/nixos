{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.oliwia.amdgpu;
in
{
  options.oliwia.amdgpu = {
    enable = lib.mkEnableOption "AMD GPU";
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      mesa
      mesa-demos
      vulkan-tools
    ];
    # enable OpenGL
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        amdvlk
      ];
    };
    services.xserver.videoDrivers = [ "amdgpu" ];
  };
}
