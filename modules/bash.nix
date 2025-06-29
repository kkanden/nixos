{ pkgs, lib', ... }:
{
  programs.bash = {
    lsColorsFile = lib'.mkConfig "ls_colors";
    interactiveShellInit = ''
      if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
      then
        shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec ${pkgs.stable.fish}/bin/fish $LOGIN_OPTION
      fi
    '';
  };
}
