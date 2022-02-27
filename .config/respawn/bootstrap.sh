#!/bin/bash

# Install and configure Salt and Homebrew. 
# Syncs dotfiles via git.
# Sets up "respawn" to manage packages via salt!!!!

BOOTSTRAP_INDICATOR=$HOME/.github/.respawn_bootstrap
RESPAWN_DIRECTORY=$HOME/.config/respawn
BREW=`which brew`

#Checking if the script has been run before
if [[ -e $BOOTSTRAP_INDICATOR ]]; then
    echo "Bootstrap has run for this user before...."
    echo "delete '~/.github/.respawn_bootstrap' to run again"
    echo "Exiting..."
    exit 0
fi


# Checking for and installing....
# Homebrew (macOS only)...
if [[ $OSTYPE = darwin* ]]; then
    echo "Checking for Homebrew"
    if [[ ! -n 'which brew' ]]; then
        echo "Homebrew not detected"
	echo "Installing Homebrew"
	echo "---- "
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    else
        echo "Homebrew is installed!"
    fi
fi

# Git...
echo "---- "
echo "Checking for Git..."
if [[ ! -n 'which git' ]]; then
    echo "Git not detected..."
    echo "Installing Git..."
    echo "---- "
    if [[ $OSTYPE = darwin* ]]; then
        $BREW install git
    elif [[ $OSTYPE = linux-gnu ]]; then
        sudo apt update && apt install git
    fi
else
    echo "Git is already installed!"
fi

# GPG...
echo "---- "
echo "Checking for GPG..."
if [[ ! -e "$(which gpg)" ]]; then
    echo "GPG not detected..."
    echo "Installing GPG..."	
    if [[ $OSTYPE = darwin* ]]; then
        $BREW install gpg
    elif [[ $OSTYPE = linux-gnu* ]]; then
        sudo apt update
        sudo apt install gpg
    fi
else
    echo "GPG already installed!"

fi

# 'Git-ing' my config files!!!!
echo "---- "
echo "Checking for .git in $HOME"
if [[ $1 == '-git' ]]; then
    echo "Deleting ~/.git and overwriting configs since you used the '-git' flag"
fi
if [[ ! -d ~/.git ]]; then
    echo "No git file in the home directory."
    echo "'Git-ing' my config files... hehe..."
    cd ~/
    git init
    git remote add origin git@github.com:jRob2k/respawn
    git fetch
    git checkout -f main
    echo "Got my config files!!!"
else
    echo "The home directory already has a git file."
    echo "Use git to fetch config files if they need to be updated"
    echo "Use the '-git' flag to overwrite local files"
fi

# Salt...
echo "---- "
echo "Checking for SALT..."
if [[ ! -n 'which salt' ]]; then
    echo "Salt not detected at '/etc/salt'"
    echo "Installing Salt..."
    echo "---- "
    curl -o bootstrap-salt.sh -L https://bootstrap.saltproject.io && sudo sh bootstrap-salt.sh
else
    echo "Salt is already  installed!"
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
/bin/bash respawn -go 

# Touching a file so bootstrap knows it's been run
echo "---- "
echo "Creating bootstrap indicator --> $BOOTSTRAP_INDICATOR"
printf -v date '%(%Y-%m-%d %H:%M:%S)T\n' -1 
echo "respawn bootstrap ran on $date" > $BOOTSTRAP_INDICATOR 


