#!/bin/bash

# Install and configure Salt and Homebrew. 
# Syncs dotfiles via git.
# Sets up "respawn" to manage packages via salt!!!!

BOOTSTRAP_INDICATOR=$HOME/.github/.respawn_bootstrap
RESPAWN_DIRECTORY=$HOME/.config/respawn

# Script Functions
# ~~~
# Check if script has been run before
check_for_previous_run () {
    # Skip check and run again if '-r' set
    if [[ $1 = -r ]]; then
      echo "*sigh*....Running bootstrap script.....again..."
    elif [[ -e $BOOTSTRAP_INDICATOR ]]; then
        echo "Bootstrap has run for this user before...."
        echo "delete '~/.github/.respawn_bootstrap' to run again"
        echo "Exiting..."
        exit 0
    fi
}
# ~~~
# Check for installed pkg. Accepts software name and which variable search as arguments respectively (i.e. Homebrew brew).
#When checking if a variable location is a directory, add the '/'!!!!!
check_for_software () {
    echo "Checking for $1..."
    if [[ ! -e "$(which $2)" ]]; then
        echo "$1 not detected."
        echo "Installing $1."
        echo "~~~~"
        install_thing $1
    else
        echo "$1 already installed!"
    fi
}
# ~~~
install_thing () {
    case "$1" in
       "Salt")
            # Salt Installation
            echo "Installing Salt. Please provide your root password."
            curl -o bootstrap-salt.sh -L https://github.com/saltstack/salt-bootstrap/releases/latest/download/bootstrap-salt.sh && sudo sh bootstrap-salt.sh
            ;;
        "Git")
            # Git Installation
            echo "Cross platform git installation not implemented. For now, just install using appropriate means and try again."
            exit 0
            ;;
       *)
            # Didn't follow instructions...
            echo "No software installation script configured for $1"
            ;;
    esac
}

# Check if script has been run before
check_for_previous_run $1

# Install Git if it's not already installed
echo "$(check_for_software "Git" "git")"
echo "~~~~"

# Install Salt if it's not already installed
echo "$(check_for_software "Salt" "salt-call")"
echo "~~~~"

# Checking for git file. Skipping if there isn't one
if [[ ! -d ~/.git ]]; then
     # Create ssh directory if it doesn't exist
    if [[ ! -d "$HOME/.ssh" ]]; then
        mkdir $HOME/.ssh
    fi
      # Git config files
    echo "'Git-ing' my config files... hehe..."
    cd ~/
    git config --global init.defaultBranch main
    git init
    git remote add origin https://github.com/jRob2k/respawn.git
    echo "Using https to fetch config files. Snag a Personal Access token and login with that"
    git fetch
    git checkout -f main
    echo "Got my config files!!!"
else
    echo "The home directory already has a git file. Skipping git steps."
fi

# Installing Powerline fonts if they aren't already 
FONTDIR=$HOME/.local/share/fonts
if [ $(ls $FONTDIR/*Powerline* 2>/dev/null | wc -l) -gt 0 ]; then 
  echo "Powerline fonts already installed"
else
  echo "Powerline fonts not found in $FONTDIR. Installing..."
  $RESPAWN_DIRECTORY/files/fonts/install.sh
fi

# Create/update minion config that points to this dir.
echo "---- "
echo "Updating the minion config to point to $RESPAWN_DIRECTORY"
echo $RESPAWN_DIRECTORY/minion
sed "s|{{ PWD }}|$RESPAWN_DIRECTORY|" $RESPAWN_DIRECTORY/minion_template > $RESPAWN_DIRECTORY/minion

# Run respawn salt highstate
echo "---- "
echo "Running Respawn Salt Highstate..."
echo "Hold on to your butts..."
cd ~/.config/respawn
chmod +x respawn
/bin/bash respawn -g 

# Touching a file so bootstrap knows it's been run
echo "---- "
echo "Creating bootstrap indicator --> $BOOTSTRAP_INDICATOR"
date=$(date)
echo "respawn bootstrap ran on $date" > $BOOTSTRAP_INDICATOR 

