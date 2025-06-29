{ ... }:
{
  programs.oh-my-posh = {
    enable = true;
    enableBashIntegration = false;
    enableFishIntegration = true;
    settings = builtins.fromJSON (builtins.readFile ../config/oh-my-posh/omp-vague.json);
  };
}
