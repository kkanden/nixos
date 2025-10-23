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

  oliwia.home = {
    configSymlink = {
      alacritty = "alacritty";
      fastfetch = "fastfetch";
      git = "git";
      hypr = "hypr";
      hyprpanel = "hyprpanel";
      "oh-my-posh/config.toml" = "oh-my-posh/omp-vague.toml";
      qimgv = "qimgv";
      ripgrep = "ripgrep";
      sioyek = "sioyek";
      tmux = "tmux";
      rofi = "rofi";
    };
  };
  home.sessionVariables."RIPGREP_CONFIG_PATH" = "$HOME/.config/ripgrep/ripgreprc";

  home.sessionVariables = {
    EDITOR = "nvim";
    BROWSER = "zen";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
