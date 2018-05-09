#1/usr/bin/env bash

# Elevate to root and keep it
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Install software
sudo apt update
sudo apt install -y git fish vim git wget tmux python3 mosh stow python-dev build-essential python-pip
# ack-grep not currently available

# Set fish as the default shell
sudo sh -c 'echo `which fish` >> /etc/shells'
chsh -s `which fish`

# Install virtualenv
pip install virtualenv || sudo pip install virtualenv

# Install sublime
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
sudo apt-get install -y apt-transport-https
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
sudo apt-get update
sudo apt-get install -y sublime-text

# Install dotfiles
stow -t ~ fish
stow -t ~ git
stow -t ~ vim
stow -t ~/.config/sublime-text-3/ sublime

