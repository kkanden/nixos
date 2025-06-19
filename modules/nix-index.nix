{ ... }:
{
  programs.nix-index = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
  };
  programs.command-not-found.enable = false;

}
