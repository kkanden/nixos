{ pkgs, lib', ... }:
{
  programs.tmux = {
    enable = true;
    shell = "${pkgs.stable.fish}/bin/fish";
    extraConfig = lib'.readConfig "tmux/tmux.conf";
    plugins = builtins.attrValues {
      inherit (pkgs.tmuxPlugins)
        yank
        resurrect
        continuum
        ;
    };
  };
}
