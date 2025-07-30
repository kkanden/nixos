{ lib', pkgs, ... }:
{
  programs.oh-my-posh = {
    enable = true;
    package = pkgs.stable.oh-my-posh;
    enableBashIntegration = false;
    enableFishIntegration = true;
    settings = builtins.fromJSON (lib'.readConfig "oh-my-posh/omp-vague.json");
  };
}
