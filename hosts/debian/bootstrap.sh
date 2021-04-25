#!/usr/bin/env bash
set -e

# Install software
sudo apt update
sudo apt install -y \
    ack \
    curl \
    fish \
    git \
    i3 \
    mosh \
    open-vm-tools-desktop \
    stow \
    tmux \
    vim \
    wget \
    xorg

# Set fish as the default shell
sudo sh -c 'echo `which fish` >> /etc/shells'
chsh -s `which fish`

# pyenv
# https://github.com/pyenv/pyenv/wiki/Common-build-problems
sudo apt install -y build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev python-openssl git
curl https://pyenv.run | bash
fish -c "set -Ux PYENV_ROOT $HOME/.pyenv"
fish -c "set -Ux fish_user_paths $PYENV_ROOT/bin $fish_user_paths"

# Install dotfiles
cd "$(git rev-parse --show-toplevel)/common"
stow -t ~ ack
stow -t ~ fish
stow -t ~ git
stow -t ~ i3
stow -t ~ vim
