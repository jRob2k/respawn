#!/bin/sh

# Install and configure Salt and Homebrew. 
# Syncs dotfiles via git.
# Sets up "respawn" to manage packages via salt!!!!

# Checking for and installing....
# Homebrew (macOS only)...
if [[ $OSTYPE = darwin* ]]; then
    echo "Checking for Homebrew"
    if [[ ! -d $BREW ]]; then
        echo "Homebrew not detected"
	echo "Installing Homebrew"
	echo "---- "
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    else
        echo "Homebrew is installed!"
    fi

# Git...
echo "Checking for Git..."
if [[ ! -n "which git" ]]; then
    echo "Git not detected..."
    echo "Installing Git..."
    echo "---- "
    if [[ $OSTYPE = darwin* ]]; then
    brew install git
    if [[ $OSTYPE = linux-gnu ]]; then
    sudo apt update && sudo apt install git
else
    echo "Git is already  installed!"
fi
# GPG...
    if [[ ! -e "$(which gpg)" ]]; then
        if [[ $OSTYPE = darwin* ]]; then
            $BREW/brew install gpg
        elif [[ $OSTYPE = linux-gnu* ]]; then
            sudo apt update
            sudo apt install gpg
        fi
    fi
 
# 'Git-ing' my config files!!!!
echo "Checking for .git at ~/"
if [[ ! -d ~/.git ]]; then
    echo "Not git file in the home directory."
    echo "'Git-ing' my config files... hehe..."
    echo "..... gotta write this part...."
else
    echo "The home directory already has a git file."
    echo "Use git to fetch config files if they need to be updated"

# Salt...
echo "Checking for SALT..."
if [[ ! -n "which salt" ]]; then
    echo "Salt not detected at '/etc/salt'"
    echo "Installing Salt..."
    echo "---- "
    curl -o bootstrap-salt.sh -L https://bootstrap.saltproject.io && sudo sh bootstrap-salt.sh
else
    echo "Salt is already  installed!"

# Create/update minion config that points to this dir.
sed "s|{{ PWD }}|$PWD|" minion_template > $PWD/minion
;;
   
fi
