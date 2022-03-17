#!/bin/bash

# Install and configure Salt and Homebrew. 
# Syncs dotfiles via git.
# Sets up "respawn" to manage packages via salt!!!!

BOOTSTRAP_INDICATOR=$HOME/.github/.respawn_bootstrap
RESPAWN_DIRECTORY=$HOME/.config/respawn
BREW=`which brew`

#Checking if the script has been run before
if [[ $1 = -r ]]; then
  echo "*sigh*....Running bootstrap script.....again..."
elif [[ -e $BOOTSTRAP_INDICATOR ]]; then
    echo "Bootstrap has run for this user before...."
    echo "delete '~/.github/.respawn_bootstrap' to run again"
    echo "Exiting..."
    exit 0
fi

# Checking for and installing....
# Homebrew...
echo "Checking for Homebrew"
if [[ ! -e "$(which brew)" ]]; then
  echo "Homebrew not detected"
	echo "Installing Homebrew"
	echo "---- "
  if [[ $OSTYPE = darwin* ]]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  # Needed to add 'CI=a' to this command for passwordless sudo environments like crostini.
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
else
  echo "Homebrew is installed!"
fi

# ZSH...
echo "---- "
echo "Checking for ZSH..."
if [[ ! -e "$(which zsh)" ]]; then
    echo "ZSH not detected..."
    echo "Installing ZSH..."
    echo "---- "
    #Don't think I need a macOS option here since they all ship with zsh now. Maybe add later when i for loop this ish
    if [[ $OSTYPE = linux-gnu ]]; then
        sudo apt update && sudo apt install zsh -y
    fi
else
    echo "ZSH is already installed!"
fi

# ZSH...
echo "---- "
echo "Checking for ZIM..."
if [[ ! -d $ZIM_HOME ]]; then
    echo "ZIM not detected..."
    echo "Installing ZIM..."
    echo "---- "
    #curl -fsSL https://raw.githubusercontent.com/zimfw/install/master/install.zsh | zsh
    echo "Installing starship"
    #$BREW install starship
    eval "$(starship init zsh)"
else
    echo "ZIM is already installed!"
fi

# Git and GH...
echo "---- "
echo "Checking for Git..."
if [[ ! -e "$(which git)" ]]; then
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

echo "---- "
echo "Checking for Github CLI..."
if [[ ! -e "$(which gh)" ]]; then
    echo "Github CLI not detected..."
    echo "Installing Github CLI..."
    echo "---- "
    $BREW install gh
else
    echo "Github CLI is already installed!"
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
        sudo apt install gpg -y
    fi
else
    echo "GPG already installed!"
fi
# SSH restore flow. Skipping if "--noauth" flag is sent
if $1 = "--noauth"; then
  echo "Skipping Auth and SSH Restore"
else
  #TODO: Get this working properly
  #Check if ssh keys exist. This probably works..
  if [ "$(ls -A ~/.ssh)" ]; then
    echo "SSH directory and keys exist. Skipping Auth and SSH Restore"
  else
  # Checking for 1Password CLI...
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
fi
    
    #TODO: Use this to sign in https://austincloud.guru/2018/11/27/1password-cli-tricks/
    #Checking 1Password signin...
    echo "---- "
    if [[ $(op account list) = "" ]]; then
      echo "No not signed into OP."
    else
      echo "Already signed into OP"
    fi

      
# 'Git-ing' my config files!!!!
# TODO figure out how to authentication first otherwise this will fail
echo "---- "
echo "Checking for .git in $HOME"
if [[ $1 == '-git' ]]; then
   echo "Deleting ~/.git and overwriting configs since you used the '-git' flag"
fi
echo "---- "
if [[ ! -d ~/.git ]]; then
    echo "No git file in the home directory."
    echo "'Git-ing' my config files... hehe..."
    cd ~/
    git config --global init.defaultBranch main
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

# Installing powerline fonts
echo "---- "
echo "Installing Powerline Fonts"
~/.config/respawn/files/fonts/install.sh

# Salt...
echo "---- "
echo "Checking for SALT..."
if [[ ! -e "$(which salt-call)" ]]; then
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
/bin/bash respawn -g 

# Touching a file so bootstrap knows it's been run
echo "---- "
echo "Creating bootstrap indicator --> $BOOTSTRAP_INDICATOR"
printf -v date '%(%Y-%m-%d %H:%M:%S)T\n' -1 
echo "respawn bootstrap ran on $date" > $BOOTSTRAP_INDICATOR 

