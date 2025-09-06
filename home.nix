{ lib', ... }:
{
  imports = map (m: ./modules-hm + "/${m}.nix") [
    "alacritty"
    "fastfetch"
    "fish"
    "git"
    "hyprland"
    "keyd-app"
    "neovim"
    "oh-my-posh"
    "ripgrep"
    "rofi"
    "theme-qt-gtk"
    "xdg"
    "zoxide"
    "options"
    "config"
  ];

  home.username = "oliwia";
  home.homeDirectory = "/home/oliwia";

  home.stateVersion = "25.05";

  home.file = {
    ".Rprofile".source = lib'.mkConfigPath ".Rprofile";
    "scripts/tmux-sessionizer" = {
      source = lib'.mkScript "tmux-sessionizer";
      executable = true;
    };
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
