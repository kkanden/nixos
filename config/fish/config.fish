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

abbr --add --set-cursor -- nrun 'nix run nixpkgs#%'

function nix
    if test "$argv[1]" = shell; or test "$argv[1]" = develop
        NIX_SHELL=1 command nix $argv
    else
        command nix $argv
    end
end

source ~/.config/fish/theme.fish
fortune | cowsay
