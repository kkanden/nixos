{ ... }:
{
  xdg = {
    enable = true;
    desktopEntries = {
      nvim-alacritty = {
        name = "Neovim in Alacritty";
        genericName = "Text Editor";
        exec = "alacritty -e nvim %F";
        icon = "alacritty";
        mimeType = [ "text/plain" ];
        terminal = false;
        categories = [
          "Utility"
          "TextEditor"
        ];
      };
    };
  };

}
