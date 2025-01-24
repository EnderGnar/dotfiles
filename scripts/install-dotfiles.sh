#!/bin/bash

# Exit the script immediately if a command fails and print commands
set -e
set -x

if [[ $# = 0 ]] ; then DF=~/.dotfiles; else DF=$1; fi

# Set config folder
C=~/.config
mkdir -pv $C

# git setup
mkdir -pv $C/git
ln $DF/git.gitconfig $C/git/config

# tmux setup
mkdir -pv $C/tmux
ln $DF/tmux.conf $C/tmux/tmux.conf

# nix
mkdir -pv $C/nix
rm $C/nix/flake.nix $C/nix/flake.lock
ln $DF/nix/flake.nix $C/nix/flake.nix
ln $DF/nix/flake.lock $C/nix/flake.lock