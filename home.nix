{ ... }:
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
    "ripgrep"
    "rofi"
    "sioyek"
    "xdg"
    "tmux"
  ];

  home.username = "oliwia";
  home.homeDirectory = "/home/oliwia";

  home.stateVersion = "25.05";

  home.file = {
    ".Rprofile".source = ./config/.Rprofile;
    "scripts/tmux-sessionizer.sh" = {
      source = ./scripts/tmux-sessionizer.sh;
      executable = true;
    };
    ".latexmkrc".source = ./config/latexmkrc;
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    BROWSER = "zen";
  };

  home.sessionPath = [ "$HOME/scripts" ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
