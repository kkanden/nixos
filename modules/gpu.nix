{ pkgs, ... }:
{
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
}
