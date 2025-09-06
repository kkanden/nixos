{ pkgs, lib', ... }:
{
  home.file."scripts/focus-or-launch" = {
    source = lib'.mkScript "focus-or-launch";
    executable = true;
  };
  home.file."scripts/killactive-steamsafe" = {
    source = lib'.mkScript "killactive-steamsafe";
    executable = true;
  };
}
