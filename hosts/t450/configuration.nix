{
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./_hardware-configuration.nix
  ]
  ++ lib.filesystem.listFilesRecursive ./imports;

  oliwia.immich = {
    server.enable = true;
    backup = {
      db.enable = true;
      assets.enable = true;
    };
  };

  services.upower.enable = true;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };

  hardware.enableAllFirmware = true;

  services.logind.settings.Login = {
    HandleLidSwitch = "ignore";
  };

  # this is just so caddy+cgit stops complaining about dubious ownership
  # idk if this is bad practice but it makes it work
  environment.etc."gitconfig".text = /* gitconfig */ ''
    [init]
      defaultBranch = main
    [core]
      sharedRepository = all
    [safe]
      directory = *
  '';

  # DON'T CHANGE!
  system.stateVersion = "26.05";
}
