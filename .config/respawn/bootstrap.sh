#!/bin/bash

# Install and configure Salt and Homebrew. 
# Syncs dotfiles via git.
# Sets up "respawn" to manage packages via salt!!!!

BOOTSTRAP_INDICATOR=$HOME/.github/.respawn_bootstrap
RESPAWN_DIRECTORY=$HOME/.config/respawn
BREW=`which brew`

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
    # Check for specific software by config
    config_software=("ZIM")
    if [[ ${config_software[*]} =~ d ]]; then
        if [[ ! -d $2 ]]; then
            echo "$1 not detected."
            echo "Installing $1."
            echo "~~~~"
            install_thing $1
        fi
    #Check by which
    elif [[ ! -e "$(which $2)" ]]; then
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
        "Homebrew")
            #Homebrew installation
            if [[ $OSTYPE = darwin* ]]; then
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
                # Needed to add 'CI=a' to this command for passwordless sudo environments like crostini.
            # Linux Installation (ChromeOS)
            elif [[ $OSTYPE = linux-gnu* ]]; then
                CI=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
                # Add Homebrew to the PATH
                echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> $HOME/.profile
                echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> $HOME/.zprofile
                eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
                # Install Homebrew's dependancies
                sudo apt-get install build-essential
                # Install GCC per Homebrew's suggestion
                brew install gcc
            fi
                #Set Homebrew variable
                BREW=`which brew`
            ;;
        "ZShell")
            # macOS installation shouldn't be necessary
            # Linux installation. 
            if [[ $OSTYPE = linux-gnu ]]; then
                sudo apt update && sudo apt install zsh -y
            fi
            ;;
        "ZIM")
            curl -fsSL https://raw.githubusercontent.com/zimfw/install/master/install.zsh | zsh
            echo "Installing starship"
            $BREW install starship
            eval "$(starship init zsh)"
            ;;
        "GIT")
            # GIT Install
            if [[ $OSTYPE = darwin* ]]; then
                $BREW install git
            elif [[ $OSTYPE = linux-gnu ]]; then
                sudo apt update && apt install git
            fi
            ;;
        "Github_CLI")
            $BREW install gh
            ;;
        "GPG")
            if [[ $OSTYPE = darwin* ]]; then
                $BREW install gpg
            elif [[ $OSTYPE = linux-gnu* ]]; then
                sudo apt update
                sudo apt install gpg -y
            fi

            ;;
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
            # Help
            echo "No software installation script configured for $1"
            ;;
    esac
}

# Softare to install as an associated array (dictionary). No spaces!
# Need to figure out the order. Homebrew should be first.
declare -A software

# ZSH
software["ZShell"]="zsh"
# Homebrew
# software["Homebrew"]="brew"
# Git
software["GIT"]="git"
# Github CLI
software["Github_CLI"]="gh"
# GPG
software["GPG"]="gpg"
# Salt
software["Salt"]="salt-call"

# Check if script has been run before
check_for_previous_run $1
# Install priority software first
echo "$(check_for_software "Homebrew" "brew")"
echo "~~~~"
# Loop through software array and install if not already installed
# For every key in the associative array..
for s in "${!software[@]}"; do
    echo "$(check_for_software $s ${software[$s]})"
    echo "~~~~"
done


#Checking for 1Password CLI...
echo "---- "
echo "Checking for 1Password CLI..."
if [[ ! -e  "$(which op)" ]]; then
  echo "1Password CLI not detected..."
  echo "Installing 1Password CLI..."
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
  else
    echo "1Password CLI is already installed!"
fi    
  # Signing into 1Password, snag my respawn key and use it with git.
echo "---- "
echo "Signing into 1Password as $1"
if [[ -z $OP_SESSION_respawn ]]; then
eval $(op signin)
fi

# TODO Use this to sign in https://austincloud.guru/2018/11/27/1password-cli-tricks/
#Getting ssh key and setting them to variables
ssh_key=$(op item get "respawn - SSH Key" --fields label=notesPlain)
#Making a temporary file to hold the ssh key
tmp_key="$(mktemp)"
#stripping the quotes from the key (artifact of 1password)
echo "${ssh_key:1:-1}" > $tmp_key
#creating a quick variable to use when Git-ing files
r="'ssh -i $tmp_key'"
echo $tmp_key

#Sign out!
op signout
unset OP_SESSION_jrob2k
      
GIT_SSH_COMMAND='ssh -i $tmp_key -o IdentitiesOnly=yes' git pull 
# 'Git-ing' my config files!!!!
# TODO figure out how to authentication first otherwise this will fail
echo "---- "
echo "Checking for .git in $HOME"
if [[ $1 == '-git' ]]; then
  echo "Deleting ~/.git and overwriting configs since you used the '-git' flag"
fi
echo "~~~~"
if [[ ! -d ~/.git ]]; then
    # Check for and install 1Password
    echo "$(check_for_software "1Password" "op")"
    # Signing into 1Password, snag my respawn key and use it with git.
    echo "---- "
    echo "Signing into 1Password as $1"
    if [[ -z $OP_SESSION_respawn ]]; then
    eval $(op signin)
    fi

    #Getting respawn ssh key and setting them to variables
    ssh_key=$(op item get "respawn - SSH Key" --fields label=notesPlain)
    #Making a temporary file to hold the ssh key
    respawn_key="$(mktemp)"
    #stripping the quotes from the key (artifact of 1password)
    echo "${ssh_key:1:-1}" > $tmp_key

    #Sign out!
    op signout
    unset OP_SESSION_respawn
        
    # Git config files
    # Using the "GIT_SSH_COMMAND" to use the respawn key
    echo "No git file in the home directory."
    echo "'Git-ing' my config files... hehe..."
    cd ~/
    git config --global init.defaultBranch main
    git init
    GIT_SSH_COMMAND='ssh -i $tmp_key -o IdentitiesOnly=yes' git remote add origin git@github.com:jRob2k/respawn
    GIT_SSH_COMMAND='ssh -i $tmp_key -o IdentitiesOnly=yes' git fetch
    GIT_SSH_COMMAND='ssh -i $tmp_key -o IdentitiesOnly=yes' git checkout -f main
    echo "Got my config files!!!"
else
    echo "The home directory already has a git file."
    echo "Use git to fetch config files if they need to be updated"
    echo "Use the '-git' flag to overwrite local files"
fi

# Installing powerline fonts
# echo "---- "
# echo "Installing Powerline Fonts"
# ~/.config/respawn/files/fonts/install.sh

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

