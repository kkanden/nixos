{
  pkgs,
  lib',
  ...
}:
{
  programs.neovim = {
    enable = true;
    plugins = [
      pkgs.vimPlugins.nvim-treesitter.withAllGrammars
    ];
  };

  home.file = {
    ".Rprofile".source = lib'.mkConfigPath ".Rprofile";
    ".latexmkrc".source = lib'.mkConfigPath "latexmkrc";
  };

  oliwia.home = {
    configSymlink = {
      alacritty = "alacritty";
      fastfetch = "fastfetch";
      clangd = "clangd";
      "fish/theme.fish" = "fish/vague.fish";
      "fish/config.fish" = "fish/config.fish";
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

  # adds xdg variables
  xdg.enable = true;

}
