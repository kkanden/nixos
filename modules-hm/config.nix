{ ... }:
{
  oliwia.home = {
    configSymlink = {
      alacritty = "alacritty";
      fastfetch = "fastfetch";
      git = "git";
      hypr = "hypr";
      hyprpanel = "hyprpanel";
      "oh-my-posh/config.json" = "oh-my-posh/omp-vague.json";
      qimgv = "qimgv";
      ripgrep = "ripgrep";
      sioyek = "sioyek";
      tmux = "tmux";
      rofi = "rofi";
    };
  };
  home.sessionVariables."RIPGREP_CONFIG_PATH" = "$HOME/.config/ripgrep/ripgreprc";
}
