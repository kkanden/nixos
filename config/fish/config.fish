set fish_greeting

function replace-command
    set cmdline $(test -n "$(commandline)" && echo $(commandline) || echo $history[1] )
    set cmdline (string split " " $cmdline)
    if test (string match --regex "sudo|systemctl" "$cmdline[1]")
        set -e cmdline[2]
        set len (string length "$cmdline[1]")
        set cmdline[1] (string join "" "$cmdline[1]" " ")
        commandline -r (string join " " -- $cmdline)
        commandline -C (math $len + 1) # position after first command
    else
        set -e cmdline[1]
        commandline -r " "(string join " " -- $cmdline)
        commandline -C 0
    end
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
alias nrepl="nixos-rebuild repl --flake $NIXOS_REPO#$hostname"
alias duf="duf -hide special"

function man
    if string match -- "-*" $argv
        command man $argv
    else
        command man $argv | bat -l man
    end
end

abbr --add --set-cursor -- nrun 'nix run nixpkgs#%'

function nix
    if test "$argv[1]" = shell; or test "$argv[1]" = develop
        NIX_SHELL=1 command nix $argv
    else
        command nix $argv
    end
end

source ~/.config/fish/theme.fish
source ~/.config/fish/prompt.fish

# do a fortune-cowsay only in top level shell (no output in tmux shells)
if not set -q COWSAY_OUT
    fortune | cowsay
    set -gx COWSAY_OUT 1
end
