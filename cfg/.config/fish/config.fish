setenv EDITOR vim

alias f "feh --auto-zoom --scale-down --draw-filename --draw-tinted"

alias g "git"

if ! which pbcopy pbpaste > /dev/null 2>&1
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

if test -f ~/.config/fish/config.local.fish
    source ~/.config/fish/config.local.fish
end
