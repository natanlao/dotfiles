#!/usr/bin/env bash
# Idempotent!
set -eux

echo "Install homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo "Install packages..."
brew install \
    ack \
    entr \
    firefox \
    fish \
    git \
    git \
    google-chrome \
    httpie \
    jq \
    lastpass \
    pycharm \
    pyenv \
    qlstephen \
    rsync \
    slack \
    spectacle \
    stoken \
    stow \
    sublime-text \
    terraform \
    tmux \
    tree \
    vim \
    webex \
    wget \
    wireguard-tools

# brew tap homebrew/cask-fonts
# brew install homebrew/cask-fonts/font-source-code-pro

# Set fish as default shell
echo "Set fish as default shell..."
grep "`which fish`" /etc/shells || sudo sh -c 'echo "`which fish`" >> /etc/shells'
chsh -s `which fish`

echo "Configuring Terminal.app..."
open Solarized\ Dark.terminal
sleep 1
defaults write com.apple.terminal "Default Window Settings" -string "Solarized Dark"
defaults write com.apple.terminal "Startup Window Settings" -string "Solarized Dark"
defaults write com.apple.terminal SecureKeyboardEntry -bool true

echo "Configuring scrolling, trackpad, and keyboard..."
defaults write -g com.apple.swipescrolldirection -bool false
defaults write -g com.apple.mouse.scaling -1
defaults write -g com.apple.trackpad.scaling 1
defaults write com.sublimetext.2 ApplePressAndHoldEnabled -bool false
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false

echo "Enabling firewall..."
sudo defaults write /Library/Preferences/com.apple.alf globalstate -int 1

echo "Installing dotfiles..."
stow -t ~ cfg  # hosts/macos/cfg/
cd "$(git rev-parse --show-toplevel)"
stow -t ~ cfg  # cfg/

echo "Don't forget to remap Caps Lock to Escape."
