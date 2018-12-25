alias g git
setenv EDITOR vim

function venv
    if test -n "$argv"
        python3 -m venv $argv
    else
        python3 -m venv venv
    end
end

function vact
    source $argv/bin/activate.fish
end

# These aliases should only be activate if the current platform
# is Ubuntu so we don't clobber macOS's builtin pbcopy/pbaste
if python -m platform | grep -qi Ubuntu
    alias pbcopy "xclip -selection clipboard"
    alias pbpaste "xclip -selection clipboard -o"
end
