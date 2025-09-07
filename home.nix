{ lib, lib', ... }:
{
  imports = lib.filesystem.listFilesRecursive ./modules-hm;
  home.username = "oliwia";
  home.homeDirectory = "/home/oliwia";

  home.stateVersion = "25.05";

  home.file = {
    ".Rprofile".source = lib'.mkConfigPath ".Rprofile";
    ".latexmkrc".source = lib'.mkConfigPath "latexmkrc";
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    BROWSER = "zen";
  };

  home.sessionPath = [ "$HOME/scripts" ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
