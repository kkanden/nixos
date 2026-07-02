function fish_prompt
    set -l last_status $status

    set -l red d8647e
    set -l purple bb9dbd
    set -l blue 6394b2
    set -l green 7fa563
    set -l white cdcdcd
    set -l grey 606079
    set -l orange e6917d
    set -l yellow f3be7c

    set -lx fish_prompt_pwd_dir_length 0

    # CWD
    set_color $blue
    echo -n (prompt_pwd)

    # GIT

    if git rev-parse --is-inside-work-tree 2>/dev/null 1>&2
        set -l branch (git branch --show-current 2>/dev/null)

        if test -z "$branch" # detached head
            set branch (git rev-parse --short HEAD 2>/dev/null)
        end

        set -l ahead (git rev-list --count @{u}..HEAD 2>/dev/null || echo 0)
        set -l behind (git rev-list --count HEAD..@{u} 2>/dev/null || echo 0)

        set -l s_a 0
        set -l s_m 0
        set -l s_d 0
        set -l u_a 0
        set -l u_m 0
        set -l u_d 0

        for line in (git status --porcelain 2>/dev/null)
            set -l col1 (string sub -l 1 $line)
            set -l col2 (string sub -s 2 -l 1 $line)

            # staged
            if test "$col1" = A
                set s_a (math $s_a + 1)
            else if test "$col1" = M -o "$col1" = R
                set s_m (math $s_m + 1)
            else if test "$col1" = D
                set s_d (math $s_d + 1)
            end

            # unstaged
            if test "$col2" = A
                set u_a (math $u_a + 1)
            else if test "$col2" = M -o "$col2" = R
                set u_m (math $u_m + 1)
            else if test "$col2" = D
                set u_d (math $u_d + 1)
            end
        end

        set_color normal
        echo -n " ($branch"

        test $ahead -gt 0 && echo -n "+$ahead" # commit
        test $behind -gt 0 && echo -n "-$behind" # pull

        echo -n ") "

        set -l staged_count (math $s_a + $s_d + $s_m)
        set -l unstaged_count (math $u_a + $u_d + $u_m)
        if test $staged_count -gt 0
            set_color $orange
            test $s_a -gt 0 && echo -n "+$s_a"
            test $s_m -gt 0 && echo -n "~$s_m"
            test $s_d -gt 0 && echo -n "-$s_d"
        end
        set_color normal
        test $staged_count -gt 0 -a $unstaged_count -gt 0 && echo -n " | "
        if test $unstaged_count -gt 0
            set_color $yellow
            test $u_a -gt 0 && echo -n "+$u_a"
            test $u_m -gt 0 && echo -n "~$u_m"
            test $u_d -gt 0 && echo -n "-$u_d"
        end
    end

    # NIX SHELL
    if test -n "$NIX_SHELL"
        set_color $blue
        echo -n " "
    end

    echo

    # USER@HOST
    set_color $grey
    echo -n "$(whoami)@$(hostname)"

    if test $last_status -eq 0
        set_color normal
    else
        set_color $red
    end
    echo -n "> "
end
