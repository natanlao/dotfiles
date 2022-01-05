function fish_prompt --description 'Write out the prompt'
    set -l last_status $status

    set -l color_cwd
    set -l suffix
    switch "$USER"
        case root toor
            if set -q fish_color_cwd_root
                set color_cwd $fish_color_cwd_root
            else
                set color_cwd $fish_color_cwd
            end
            set suffix '#'
        case '*'
            set color_cwd $fish_color_cwd
            set suffix '>'
    end

    set -l nix_status (test -n "$IN_NIX_SHELL"; and echo -n "λ ")
    set -l prompt_nix (set_color blue) $nix_status (set_color normal)

    set -l user_status (
        if set -q SSH_CLIENT; or set -q SSH_TTY
            echo -n (set_color $fish_color_user) "$USER" (set_color normal) '@'
            echo -n (set_color $fish_color_host) (prompt_hostname) (set_color normal)
        end
    )
    set -l prompt_who (set_color normal) $user_status (set_color normal)

    set -l prompt_cwd (set_color $color_cwd) (prompt_pwd) (set_color normal)

    set -l prompt_git (set_color normal) (__fish_git_prompt) (set_color normal)

    set -l exit_status (test $last_status -ne 0; and echo -n " [$last_status]")
    set -l prompt_status (set_color $fish_color_status) $exit_status (set_color normal)

    echo -ns $prompt_nix $prompt_who $prompt_cwd $prompt_git $prompt_status $suffix " "
end
