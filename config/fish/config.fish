oh-my-posh init fish --config ~/.config/oh-my-posh/config.toml | source
set fish_greeting

bind \t accept-autosuggestion
bind \cn complete-and-search
bind \cp down-or-search
bind \cf tmux-sessionizer

alias r="R"
alias gs="git status"
alias la="ls -la"
alias nho="nh os switch"
alias nix-shell="NIX_SHELL=1 command nix-shell"
alias tree="tree -C"
alias nrepl="nix repl --expr 'let flake = (builtins.getFlake \"$NIXOS_REPO\").nixosConfigurations.$hostname; in {inherit (flake) pkgs lib config;}'"

abbr --add --set-cursor -- nrun 'nix run nixpkgs#%'

function nix
    if test "$argv[1]" = shell; or test "$argv[1]" = develop
        NIX_SHELL=1 command nix $argv
    else
        command nix $argv
    end
end

source ~/.config/fish/theme.fish

# do a fortune-cowsay only in top level shell (no output in tmux shells)
if not set -q COWSAY_OUT
    fortune | cowsay
    set -gx COWSAY_OUT 1
end
