alias g git
setenv EDITOR vim

# Start ssh-agent
# Adapted from https://superuser.com/a/996128
if test -z "(command pgrep ssh-agent)" -a -S !\($SSH_AUTH_SOCK\)
    eval (command ssh-agent -c | sed -E 's/^setenv (.+);$/set \1; set -Ux \1;/')
end
