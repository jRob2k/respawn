#!/bin/zsh

#Performing platform specific actions
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux Stuff
    echo "~Linux~"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    # Mac OSX
    if [[ $(arch) = arm64 ]]; then
        BREW='/opt/homebrew/bin'
    echo "~macOS arm64~"
    else
    echo "~macOS~"
        BREW='/usr/local/Cellar'
    fi
fi

#Presenting a platform specific help menu
function help() {
            echo "---- "
            echo "$0 accepts the following commands:"
            if [[ $OSTYPE = linux-gnu* ]]; then
        echo "---- "
        echo "bootstrap (install homebrew and configure salt)"
            echo "decrypt (install gpg and decrypt to dotfiles project)"
            echo "go (run the Salt high state)"
            echo "-s <state> (runs one state instead of the entire highstate)"
            elif [[ $OSTYPE = darwin* ]]; then
                echo "bootstrap (install homebrew and configure salt)"
        echo "decrypt (install gpg and decrypt to dotfiles project)"
        echo "---- "
            echo "brew (install brew and brew cask apps)"
            echo "go (run the Salt high state)"
            echo "-s <state> (runs one state instead of the entire highstate)"
            fi
}

function sc() {
        if [[ $OSTYPE = darwin* ]]; then
            sudo /opt/salt/bin/salt-call \
                --config-dir=${PWD} \
                state.apply $state \
                pillar="{'user': '$USER', 'home': '$HOME', 'secrets_dir': '$PWD/secrets'}" 
        elif [[ $OSTYPE = linux-gnu* ]]; then
            echo $OSTYPE
            sudo salt-call \
                --config-dir=${PWD} \
                state.apply $state \
                pillar="{'user': '$USER', 'home': '$HOME', 'secrets_dir': '$PWD/secrets'}" 
        fi
}

echo

case "$1" in
    # Display help to user
    "-h" | "--help")
    help
    ;;

    # Configure Salt and homebrew if necessary
    "bootstrap")
    #Install hombrew on macOS if it's not there yet
    if [[ $OSTYPE = darwin* ]]; then
    	if [[ ! -d $BREW ]]; then
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
        fi
    elif [[ $OSTYPE = linux* ]]; then
    	if [[ ! -d /etc/salt ]]; then
        	echo "Salt not detected at '/etc/salt'"
		echo "Installing Salt..."
		echo "---- "
		curl -o bootstrap-salt.sh -L https://bootstrap.saltproject.io
		sudo sh bootstrap-salt.sh
        fi
	if [[ ! -d /bin/gh ]]; then
		echo "Installing GH..."
		echo "---- "
		curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
		echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
		sudo apt update
		sudo apt install gh
		gh auth login
    	fi
    fi
    # Create/update minion config that points to this dir.
    sed "s|{{ PWD }}|$PWD|" minion_template > $PWD/minion
    ;;

    #Decrypt Serets
    "decrypt")
        # Change this to desired secret storage.
        SECRETS_SOURCE_DIR=$2

        # Ensure the secrets folder exists.
        if [[ ! -d $PWD/secrets ]]; then
            mkdir secrets
        fi

        # Install gpg if needed.
        if [[ ! -e "$(which gpg)" ]]; then
            #for macOS
            if [[ $OSTYPE = darwin* ]]; then
                $BREW/brew install gpg
            elif [[ $OSTYPE = linux-gnu* ]]; then
                sudo apt update
                sudo apt install gpg
            fi
        fi

        # Start decrypting.
        if [[ ! -e $PWD/secrets/id_rsa ]]; then
            for f in "$SECRETS_SOURCE_DIR"/*(D); do
        echo $f
        read -q "Hit any key to decrypt"
                $BREW/gpg --output $PWD/secrets/$(basename $f) --decrypt "$f"
            done
            chmod -R 700 secrets
        fi
        ;;
    #Use homebrew to install pkgs
    "brew")
    if [[ $OSTYPE = "darwin"* ]]; then
        HOMEBREW_PKGS=(
                awscli
                cowsay
                dockutil
                enchant
                figlet
                fortune
                fzf
                go
                gpg
                joplin
                libdvdcss
                nethack
                nmap
                pandoc
            pinentry-mac
                postgresql
                readline
                reattach-to-user-namespace
                sqlite
                tmux
                tree
                vim
                youtube-dl
                homebrew/cask/atom
                homebrew/cask/calibre
                homebrew/cask/chromedriver
                homebrew/cask/dwarf-fortress-lmp
                homebrew/cask/evernote
                homebrew/cask/grandperspective
                homebrew/cask/handbrake
                homebrew/cask/iterm2
                homebrew/cask/joplin
                homebrew/cask/openemu
                homebrew/cask/pacifist
                homebrew/cask/packages
                homebrew/cask/qlmarkdown
                homebrew/cask/skitch
                homebrew/cask/spotify
                homebrew/cask/steam
                homebrew/cask/suspicious-package
                homebrew/cask/trainerroad
                homebrew/cask/vlc
                homebrew/cask/wireshark)
        for pkg in $HOMEBREW_PKGS; do
            $BREW/brew install $pkg
        done;
    else
        echo "Haven't added targeted apt equivalent yet"
    fi
    ;;

    #Salt states
    "-s")
    state=$2
    sc
        ;;

    #Salt highstate
    "go")
    state=""
    sc

        # Launch fish if it's not already the shell.
        if [[ $(echo $SHELL) != '/bin/fish' ]]; then
            /bin/fish
        fi
        ;;
    *)

    help
    ;;
esac

