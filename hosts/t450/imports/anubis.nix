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
      |> lib.mkMerge;
    defaultOptions = {
      settings = {
        BIND_NETWORK = "tcp";
        METRICS_BIND_NETWORK = "tcp";
        SERVE_ROBOTS_TXT = true;
      };
      policy.settings.thresholds = [
        {
          name = "no-suspicion"; # eg. curl agents
          expression = "weight <= 0";
          action = "ALLOW";
        }
        {
          name = "mild-suspicion";
          expression = "weight < 20";
          action = "CHALLENGE";
          challenge = {
            algorithm = "fast";
            difficulty = 4;
          };
        }
        {
          name = "moderate-suspicion";
          expression.all = [
            "weight >= 20"
            "weight < 30"
          ];
          action = "CHALLENGE";
          challenge = {
            algorithm = "fast";
            difficulty = 6;
          };
        }
        {
          name = "high-suspicion";
          expression = "weight >= 30";
          action = "CHALLENGE";
          challenge = {
            algorithm = "fast";
            difficulty = 8;
          };
        }
      ];
    };
  };
}
