alias g git
setenv EDITOR vim
# These aliases should only be activate if the current platform
# is Ubuntu so we don't clobber macOS's builtin pbcopy/pbaste
if python -m platform | grep -qi Ubuntu
    alias pbcopy "xclip -selection clipboard"
    alias pbpaste "xclip -selection clipboard -o"
end
