{
  lib,
  lib',
  pkgs,
  osConfig,
  ...
}:
{
  imports = lib.filesystem.listFilesRecursive ./modules-hm;
  home.username = "oliwia";
  home.homeDirectory = "/home/oliwia";

  home.stateVersion = "25.05";

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

  home.pointerCursor = {
    enable = true;
    package = pkgs.phinger-cursors;
    name = "phinger-cursors-dark";
    size = 24;
    gtk.enable = true;
    hyprcursor.enable = osConfig.oliwia.hyprland.enable;
  };

  xdg.enable = true;

  # QT & GTK options
  qt = {
    enable = true;
    platformTheme.name = "adwaita";
    style.name = "adwaita-dark";
  };
  gtk = {
    enable = true;
    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };
    theme = {
      package = pkgs.gnome-themes-extra;
      name = "Adwaita";
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
