oh-my-posh init fish --config ~/.config/oh-my-posh/config.toml | source
set fish_greeting

function replace-command
    set cmdline $(test -n "$(commandline)" && echo $(commandline) || echo $history[1] )
    set cmdline (string split " " $cmdline)
    set -e cmdline[1]
    commandline -r " $cmdline"
    commandline -C 0
end

bind tab accept-autosuggestion
bind ctrl-n complete-and-search
bind ctrl-p down-or-search
bind alt-r replace-command
bind ctrl-f tmux-sessionizer

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
