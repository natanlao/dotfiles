#1/usr/bin/env bash

# Elevate to root and keep it
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Install software
sudo apt-get install -y python git fish vim ack git wget tmux python3 mosh stow

# Set fish as the default shell
sudo sh -c 'echo "/usr/local/bin/fish" >> /etc/shells'
chsh -s /usr/local/bin/fish

# Install virtualenv
pip install virtualenv || sudo pip install virtualenv

# Install dotfiles
stow -t ~ fish
stow -t ~ git
stow -t ~ vim

