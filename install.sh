#!/bin/bash

source ./install-functions

# Link to system git bash completion script (if installed)
if [ -r /usr/share/bash-completion/completions/git ]
then
    mklink /usr/share/bash-completion/completions/git ~/.git-completion.bash
fi

mklink $PWD/inputrc       ~/.inputrc
mklink $PWD/mybashrc      ~/.mybashrc
mklink $PWD/gitconfig     ~/.gitconfig
mklink $PWD/gitexcludes   ~/.gitexcludes

# Powerline
mkdir -p ~/.config/powerline
mklink $PWD/powerline_config.json  ~/.config/powerline/config.json

# Load our bash magic on login
if [ -r ~/.bashrc ]
then
    append ~/.bashrc bash-append
else
    echo "?No .bashrc file in $HOME, unsure how to proceed"
    # TODO  Create simple .bashrc?
fi

