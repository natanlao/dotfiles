setenv EDITOR vim

# This config is used across many different machines, so it's a good idea to
# be careful not to clobber anything by accident.

if command -sq feh
    alias f "feh --auto-zoom --scale-down --draw-filename --draw-tinted"
end

if command -sq git
    alias g git
    alias git-root "cd (git rev-parse --show-cdup)"
end

if command -sq terraform
    alias tf terraform
end

function _lightmode
    if command -sq alacritty
        ln -sf ~/.config/alacritty/solarized-light.yml ~/.config/alacritty/alacritty.yml
    end
    if command -sq vim
        set --universal __VIM_COLOR_SCHEME "light"
    end
end

function _darkmode
    if command -sq alacritty
        ln -sf ~/.config/alacritty/solarized-dark.yml ~/.config/alacritty/alacritty.yml
    end
    if command -sq vim
        set --universal __VIM_COLOR_SCHEME "dark"
    end
end

if ! command -sq pbcopy; and ! command -sq pbpaste; and command -sq xclip
    alias pbcopy "xclip -selection clipboard"
    alias pbpaste "xclip -selection clipboard -o"
end

if command -sq python3
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
end

if test -f ~/.config/fish/config.local.fish
    source ~/.config/fish/config.local.fish
end
