#!/bin/sh
#Presenting a platform specific help menu
function help() {
    echo "---- "
    echo "$0 accepts the following commands:"
    if [[ $OSTYPE = linux-gnu* ]]; then
        echo "---- "
        echo "-h | --help (This help menu!!!)"
        echo "go (run the Salt high state)"
        echo "-s <state> (runs one state instead of the entire highstate)"
    elif [[ $OSTYPE = darwin* ]]; then
        echo "---- "
        echo "-h | --help (This help menu!!!)"
        echo "go (run the Salt high state)"
        echo "-s <state> (runs one state instead of the entire highstate)"
    fi
}

# Finding salt installation and setting variable
SALT=$(which salt-call)
function sc() {
    sudo "$SALT" \
        --config-dir="${PWD}" \
        state.apply "$state" \
        pillar="{'user': '$USER', 'home': '$HOME', 'secrets_dir': '$PWD/secrets'}" 
}


case "$1" in
    # Display help to user
    "-h" | "--help")
    help
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

