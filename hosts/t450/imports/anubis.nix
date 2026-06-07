{ lib, ... }:
let
  # `port` is the port the actual service is running on
  # we bind anubis to `port + 1`
  mkAnubis =
    { name, port }:
    {
      ${name}.settings = {
        BIND = ":${toString (port + 1)}";
        METRICS_BIND = "127.0.0.1:${toString (port + 1000)}";
        TARGET = "http://localhost:${toString port}";
      };
    };
in
{
  services.anubis = {
    defaultOptions.settings = {
      BIND_NETWORK = "tcp";
      METRICS_BIND_NETWORK = "tcp";
      DIFFICULTY = 5;
      SERVE_ROBOTS_TXT = true;
    };
    instances =
      [
        {
          name = "www";
          port = 8200;
        }
        {
          name = "git";
          port = 8202;
        }
        {
          name = "immich-share";
          port = 8204;
        }
      ]
      |> map mkAnubis
      |> lib.mergeAttrsList;
  };
}
