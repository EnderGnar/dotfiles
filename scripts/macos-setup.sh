#!/bin/bash

# Can be run directly from the web with:
#
#   `curl --proto '=https' --tlsv1.2 -sSf -L https://raw.githubusercontent.com/EnderGnar/dotfiles/refs/heads/master/scripts/macos-setup.sh | sh -s -- install`
#

# Exit the script immediately if a command fails and print commands
set -e
set -x

# Get the Determinate Nix installer and install Nix.
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

# Get my Nix files.
mkdir -pv ~/.config/nix
curl >~/.config/nix/flake.nix  --proto '=https' --tlsv1.2 -sSf -L \
    https://raw.githubusercontent.com/EnderGnar/dotfiles/refs/heads/master/nix/flake.nix

curl >~/.config/nix/flake.lock --proto '=https' --tlsv1.2 -sSf -L \
    https://raw.githubusercontent.com/EnderGnar/dotfiles/refs/heads/master/nix/flake.lock

nix run nix-darwin -- switch --flake ~/.config/nix#macbook

git clone https://github.com/EnderGnar/dotfiles.git ~/.dotfiles
. ~/.dotfiles/scripts/install-dotfiles.sh ~/.dotfiles