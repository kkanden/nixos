{ lib', ... }:
{
  imports = map (m: ./modules-hm + "/${m}.nix") [
    "alacritty"
    "fastfetch"
    "fish"
    "git"
    "hyprland"
    "hyprpanel"
    "kdeconnect"
    "keyd-app"
    "neovim"
    "oh-my-posh"
    "qimgv"
    "ripgrep"
    "rofi"
    "sioyek"
    "theme-qt-gtk"
    "tmux"
    "xdg"
    "zoxide"
  ];

  home.username = "oliwia";
  home.homeDirectory = "/home/oliwia";

  home.stateVersion = "25.05";

  home.file = {
    ".Rprofile".source = lib'.mkConfig ".Rprofile";
    "scripts/tmux-sessionizer" = {
      source = lib'.mkScript "tmux-sessionizer";
      executable = true;
    };
    ".latexmkrc".source = lib'.mkConfig "latexmkrc";
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    BROWSER = "zen";
  };

  home.sessionPath = [ "$HOME/scripts" ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
