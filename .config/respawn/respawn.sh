#!/bin/sh
#Presenting a platform specific help menu
function help() {
    echo "~~~~ $OSTYPE ~~~~"
    echo "$0 accepts the following commands:"
        echo "---- "
        echo "-h | --help (This help menu!!!)"
        echo "-g | --go (run the Salt high state)"
        echo "-s | --salt <state> (runs one state instead of the entire highstate)"
}

# Finding salt installation and setting variable
SALT=$(which salt-call)
function sc() {
    sudo "$SALT" \
        --config-dir="${PWD}" \
        $salt_command $state \
        pillar="{'user': '$USER', 'home': '$HOME', 'secrets_dir': '$PWD/secrets'}" 
}


case "$1" in
    # Display help to user
    "-h" | "--help")
    help
    ;;

    #Salt states
    "-s" | "--salt")
    salt_command="state.apply"
    state=$2
    sc
    ;;

    #Salt highstate
    "-g" | "--go")
    salt_command="state.apply"
    state=""
    sc

        # Launch fish if it's not already the shell.
        if [[ $(echo $SHELL) != '/bin/fish' ]]; then
            /bin/fish
        fi
        ;;

    #Launch help
    *)
    help
    ;;
esac

