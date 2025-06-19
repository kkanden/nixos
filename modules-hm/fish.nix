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
    functions = {
      nixos = {
        body =
          # fish
          ''
            trap popd EXIT

            if test (count $argv) -eq 0
              set argv[1] "switch"
            end
            pushd /etc/nixos
            sudo nixos-rebuild --flake . $argv[1]
            popd
          '';
      };
    };
    interactiveShellInit =
      # fish
      ''
        set fish_greeting

        bind \t accept-autosuggestion
        bind \cn complete-and-search

        bind \cf 'tmux-sessionizer.sh'

        source ${lib'.mkConfig "fish/vague.fish"}
        fortune | cowsay
      '';
  };
}
