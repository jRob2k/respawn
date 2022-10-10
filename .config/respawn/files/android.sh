#!/bin/bash
# Minimal config for android devices since salt isn't supported.

RESPAWN_DIRECTORY=$HOME/.config/respawn

# Script Functions
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
       "SpaceVim")
            # SpaceVim Installation
            echo "Installing SpaceVim"
	    curl -sLf https://spacevim.org/install.sh | bash 
            ;;
        "PowerlineFonts")
            # Powerline Fonts Installation
	    echo "Installing Powerline Fonts"
	    fonts/install.sh
            ;;
        "Python3")
            # Python3 Installation
	    echo "Installing Python3 Fonts"
	    apt update && apt install Python3 -y
       *)
            # Didn't follow instructions...
            echo "No software installation script configured for $1"
            ;;
    esac
}


# Install SpaceVim if it's not already installed
echo "$(check_for_software "SpaceVim" "spacevim")"
echo "~~~~"

# Install NerdFonts if it's not already installed
echo "$(check_for_software "PowerlineFonts" "powerlinefonts")"
echo "~~~~"

# Install Python3 if it's not already installed
echo "$(check_for_software "Python" "python3")"
echo "~~~~"

# Install Pipenv if it's not already installed
echo "$(check_for_software "Pipenv" "pipenv")"
echo "~~~~"

