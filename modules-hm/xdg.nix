{ ... }:
{
  xdg = {
    enable = true;
    desktopEntries = {
      nautilus = {
        name = "Nautilus";
        genericName = "File explorer";
        exec = "nautilus";
        icon = "nautilus";
        mimeType = [ "text/plain" ];
      };
    };
  };

}
