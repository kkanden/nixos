{ lib', ... }:
{
  programs.oh-my-posh = {
    enable = true;
    enableBashIntegration = false;
    enableFishIntegration = true;
    settings = builtins.fromJSON (lib'.readConfig "oh-my-posh/omp-vague.json");
  };
}
