{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.oliwia.fish;
in
{

  options.oliwia.fish = {
    enable = lib.mkEnableOption "fish as interactive shell";
    stable = lib.mkEnableOption "overlaying the fish package with the stable one.";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      programs.fish.enable = true;
      # run fish if parent process is not fish and user is oliwia and set the SHELL variable
      programs.bash.interactiveShellInit = ''
        if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} && $USER == "oliwia" ]]; then
            shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
            SHELL="${pkgs.fish}/bin/fish" exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
        fi
      '';
    })
    (lib.mkIf cfg.stable {
      nixpkgs.overlays = [
        (final: prev: {
          fish = prev.pkgs.stable.fish;
          fishPlugins = prev.pkgs.stable.fishPlugins;
        })
      ];
    })
  ];
}
