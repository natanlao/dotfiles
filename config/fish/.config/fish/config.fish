setenv EDITOR vim

alias f "feh --auto-zoom --scale-down --draw-filename --draw-tinted"

alias g "git"

if ! type -q pbcopy and ! type -q pbpaste
    alias pbcopy "xclip -selection clipboard"
    alias pbpaste "xclip -selection clipboard -o"
end

function vact
    source $argv/bin/activate.fish
end

function venv
    if test -n "$argv"
        python3 -m venv $argv
    else
        python3 -m venv venv
    end
end
