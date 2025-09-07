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
        oh-my-posh init fish --config ~/.config/oh-my-posh/config.json | source
        zoxide init fish | source
        set fish_greeting

        bind \t accept-autosuggestion
        bind \cn complete-and-search
        bind \cp down-or-search

        bind \cf 'tmux-sessionizer'

        fzf_configure_bindings --variable=

        source ${lib'.mkConfigPath "fish/vague.fish"}
        fortune | cowsay
      '';
  };
}
