{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.keyd ];

  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        settings = {
          main = {
            meta = "oneshot(meta)";
          };
        };
      };
    };
  };

  systemd.services."keyd-application-mapper" = {
    enable = true;
    path = [ pkgs.keyd ];
    script = "keyd-application-mapper -d";
    restartIfChanged = true;
  };

}
