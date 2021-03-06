#!/usr/bin/env bash
set -e

# Elevate to root and keep it
# Gratefully borrowed from https://github.com/mathiasbynens/dotfiles
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Install homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Install packages
brew install python git fish vim ack git wget tmux python3 mosh stow rsync
brew tap caskroom/fonts
brew tap caskroom/drivers
brew cask install google-chrome spotify google-chrome sublime-text spectacle macpass caskroom/fonts/font-source-code-pro displaylink qlstephen

# Set fish as default shell
sudo sh -c 'echo "`which fish`" >> /etc/shells'
chsh -s `which fish`

# Perform a little more setup for Sublime Text
# Do this before installing dotfiles so that Sublime config is properly installed
subl # open sublime text
# Install package control
wget https://packagecontrol.io/Package%20Control.sublime-package -P ~/Library/Application\ Support/Sublime\ Text\ 3/Installed\ Packages/
pip3 install pylint

# Install virtualenv
pip3 install virtualenv || sudo pip3 install virtualenv

# Terminal.app can't be easily configured with `stow`
open Smyck.terminal
sleep 1
defaults write com.apple.terminal "Default Window Settings" -string "Smyck"
defaults write com.apple.terminal "Startup Window Settings" -string "Smyck"
defaults write com.apple.terminal SecureKeyboardEntry -bool true

# Post-dotfiles macOS config
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false
defaults write -g com.apple.mouse.scaling 2
defaults write -g com.apple.trackpad.scaling 3.5
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false

sudo defaults write /Library/Preferences/com.apple.alf globalstate -int 1

# Install dotfiles
cd "$(git rev-parse --show-toplevel)/common"
stow -t ~ ack
stow -t ~ bash
stow -t ~ fish
stow -t ~ git
stow -t ~ vim
