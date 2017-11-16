#!/usr/bin/env bash
# Install homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Install packages
brew install python git fish vim ack git wget tmux python3 mosh stow
brew cask install google-chrome spotify google-chrome sublime-text spectacle

# Set fish as default shell
sudo echo "/usr/local/bin/fish" >> /etc/shells
chsh -s /usr/local/bin/fish

# Perform a little more setup for Sublime Text
# Do this before installing dotfiles so that Sublime config is properly installed
subl # open sublime text
# Install package control
wget https://packagecontrol.io/Package%20Control.sublime-package -P ~/Library/Application\ Support/Sublime\ Text\ 3/Installed\ Packages/
pip3 install pylint

# Install virtualenv
pip3 install virtualenv || sudo pip3 install virtualenv

# Install dotfiles
stow fish
stow git
stow macos
stow sublime
stow vim

