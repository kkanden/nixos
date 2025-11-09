{ pkgs, lib', ... }:
{
  programs.fish = {
    enable = true;
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
      nix-shell = "NIX_SHELL=1 nix-shell";
    };
    shellAbbrs = {
      tree = "tree -C";
      nrun = {
        setCursor = true;
        expansion = "nix run nixpkgs#%";
      };
    };
    functions = {
      nix = ''
        if test "$argv[1]" = "shell"; or test "$argv[1]" = "develop"
          NIX_SHELL=1 command nix $argv
        else
          command nix $argv
        end
      '';
    };
    interactiveShellInit =
      # fish
      ''
        oh-my-posh init fish --config ~/.config/oh-my-posh/config.toml | source
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

  home.sessionVariables."SHELL" = "${pkgs.fish}/bin/fish";
}
