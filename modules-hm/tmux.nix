{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    shell = "${pkgs.stable.fish}/bin/fish";
    extraConfig = builtins.readFile ../config/tmux/tmux.conf;
    plugins = with pkgs.tmuxPlugins; [
      yank
      resurrect
      continuum
    ];
  };
}
