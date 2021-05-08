# dotfiles

Configuration for the tools / programs / games / etc. that I use, and for all of
my hosts running NixOS.


## Structure

- `app/` contains configuration files for programs that need special care to
  `stow`

- `cfg/` contains configuration files for programs that can be readily `stow`ed

- `configuration.nix` imports host-specific NixOS configuration and contains
  config shared between all NixOS hosts

- `host/` is a symlink to the active host folder in `hosts/` on NixOS systems

- `hosts/` contains per-host configuration

I've opted to `stow` dotfiles, stored separately from my NixOS config (as
opposed to using home-manager), to maintain compatibility for the non-NixOS
systems that I work from.

### Hostnames

Hostnames are compliant with [RFC 1178](https://tools.ietf.org/html/rfc1178).
All hosts take the name of an Avatar (from The Last Airbender) that lived
between Aang and Wan, exclusive. The most obvious drawback is that there are
only six names in the hostname pool. The less-obvious drawback is that, while
still a great show, The Last Airbender is seemingly much more popular now than
when I started using this theme. RFC 1178 explicitly advises against worrying
about collisions, but I might not have chosen this theme now given its
popularity.

That said, at least one such host has been active since I began using this theme
some years ago, so for the sake of consistency, it will stay.


## Setup

### NixOS

I'll update this with actual instructions down the line, but the process
generally looks like this.

1. Save the original /etc/nixos for propriety:

       sudo mv /etc/nixos ~/nixos.bak

2. Clone this repository to /etc/nixos (chown as needed):

       git clone https://github.com:natanlao/dotfiles.git /etc/nixos

3. Activate the right host:

       cd /etc/nixos
       ln -s host hosts/$(hostname)

4.     sudo nixos-rebuild switch

5. `stow` dotfiles (see below).

### Non-NixOS

1. Clone this repo to ~/.dotfiles:

       git clone https://github.com/natanlao/dotfiles.git ~/.dotfiles

2. If there's a host-specific bootstrapping script, run it:

       sh hosts/$(hostname)/bootstrap.sh

3. `stow` dotfiles (see below).


### Dotfiles

First, dry run for good luck:

    stow -nt ~ cfg

Then fire:

    stow -t ~ cfg


## Acknowledgements

I stole this repository structure from
[barrucadu/nixfiles](https://github.com/barrucadu/nixfiles).
