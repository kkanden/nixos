{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.oliwia = {
    fishInteractiveShell.enable = lib.mkEnableOption "fish as login shell";
  };
  config = lib.mkIf config.oliwia.fishInteractiveShell.enable {
    programs.bash = {
      interactiveShellInit = ''
        if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
        then
          shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
          exec ${pkgs.stable.fish}/bin/fish $LOGIN_OPTION
        fi
      '';
    };
  };
}
