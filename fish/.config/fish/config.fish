alias g git
setenv EDITOR vim

# Start ssh-agent (from https://superuser.com/a/996128)
if begin; test -z (command pgrep ssh-agent); and not test -S $SSH_AUTH_SOCK; end
    eval (command ssh-agent -c | sed -E 's/^setenv (.+);$/set \1; set -Ux \1;/')
end
