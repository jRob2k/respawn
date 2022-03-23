#!/bin/bash

# Install and configure Salt and Homebrew. 
# Syncs dotfiles via git.
# Sets up "respawn" to manage packages via salt!!!!

BOOTSTRAP_INDICATOR=$HOME/.github/.respawn_bootstrap
RESPAWN_DIRECTORY=$HOME/.config/respawn
RESPAWN_KEY=$HOME/.ssh/respawn_key

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
            curl -o bootstrap-salt.sh -L https://bootstrap.saltproject.io && sudo sh bootstrap-salt.sh
            ;;
        "1Password")
            if [[ $OSTYPE = linux-gnu* ]]; then
                #Adding the key for the 1Password Apt repository
                curl -sS https://downloads.1password.com/linux/keys/1password.asc | \
                sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg

                #Add the 1Password Apt repository
                echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/$(dpkg --print-architecture) stable main" |
                sudo tee /etc/apt/sources.list.d/1password.list

                # Add the debsig-verify policy:
                sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22/
                curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol | \
                sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol
                sudo mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22
                curl -sS https://downloads.1password.com/linux/keys/1password.asc | \
                sudo gpg --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg

                #Install 1Password CLI
                sudo apt update && sudo apt install 1password-cli
            fi
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

echo "~~~~ "
# Checking for git file. Skipping if there isn't one
if [[ ! -d ~/.git ]]; then
    # Check for respawn key and get one if it doesn't
    if [[ -e $RESPAWN_KEY ]]; then
        echo "Respawn key, already exists!"
    else
        echo "No Respawn key, obtaining one...."
        # Check for and install 1Password
        echo "$(check_for_software "1Password" "op")"
        # Sign into 1Password, get my respawn key and save to .ssh.
         # Create ssh directory if it doesn't exist
        if [[ ! -d "$HOME/.ssh" ]]; then
            mkdir $HOME/.ssh
        fi
        touch $RESPAWN_KEY
        echo "Signing into 1Password"
        if [[ -z $OP_SESSION_respawn ]]; then
            eval $(op signin)
        fi
        # Getting respawn ssh key
        ssh_key=$(op item get "respawn - SSH Key" --fields label=notesPlain)
        # Strip quotes from the key (artifact of 1password) and save as respawn key
        echo "${ssh_key:1:-1}" > $RESPAWN_KEY
        sudo chmod 0600 $RESPAWN_KEY

        #Sign out!
        op signout
        unset OP_SESSION_respawn
    fi        
    # Git config files
    # Setting the "GIT_SSH_COMMAND" env variable so git uses the respawn key
    export GIT_SSH_COMMAND="ssh -i $RESPAWN_KEY -o IdentitiesOnly=yes"
    echo "'Git-ing' my config files... hehe..."
    cd ~/
    git config --global init.defaultBranch main
    git init
    git remote add origin git@github.com:jRob2k/respawn
    git fetch
    git checkout -f main
    # Unsetting GIT_SSH_COMMAND so normal SSH keys from the config are used
    unset GIT_SSH_COMMAND
    echo "Got my config files!!!"
else
    echo "The home directory already has a git file. Skipping git steps."
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
printf -v date '%(%Y-%m-%d %H:%M:%S)T\n' -1 
echo "respawn bootstrap ran on $date" > $BOOTSTRAP_INDICATOR 

