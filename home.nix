{
  pkgs,
  lib',
  ...
}:
{
  programs.bash.enable = true; # required for home.sessionVariables to work
  programs.neovim = {
    enable = true;
    plugins = [
      pkgs.vimPlugins.nvim-treesitter-legacy.withAllGrammars
    ];
  };

  home.file = {
    ".Rprofile".source = lib'.mkConfigPath ".Rprofile";
    ".latexmkrc".source = lib'.mkConfigPath "latexmkrc";
  };

  oliwia.home = {
    configSymlink = {
      alacritty = "alacritty";
      bat = "bat";
      fastfetch = "fastfetch";
      clangd = "clangd";
      dust = "dust";
      "fish/theme.fish" = "fish/vague.fish";
      "fish/config.fish" = "fish/config.fish";
      fzf = "fzf";
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
  home.sessionVariables."FZF_DEFAULT_OPTS_FILE" = "$HOME/.config/fzf/config";

  # adds xdg variables
  xdg.enable = true;

}
