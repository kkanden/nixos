{ pkgs, lib', ... }:
{
  programs.fish = {
    enable = true;
    package = pkgs.stable.fish;
    plugins = [
      {
        name = "fzf";
        src = pkgs.fishPlugins.fzf-fish.src;
      }
    ];
    shellAliases = {
      r = "R";
      gs = "git status";
      la = "ls -la";
      nho = "nh os switch";
    };
    shellAbbrs = {
      tree = "tree -C";
    };
    interactiveShellInit =
      # fish
      ''
        set fish_greeting

        bind \t accept-autosuggestion
        bind \cn complete-and-search

        bind \cf 'tmux-sessionizer'

        fzf_configure_bindings --variable=

        source ${lib'.mkConfig "fish/vague.fish"}
        fortune | cowsay
      '';
  };
}
