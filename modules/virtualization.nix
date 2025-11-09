{ lib, ... }:
{
  options = {
    oliwia.virtualization.enable = lib.mkEnableOption "virtualization";
  };
  config = {
    virtualisation.libvirtd.enable = true;
    programs.virt-manager.enable = true;
  };
}
