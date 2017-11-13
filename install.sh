#!/bin/bash

source ./install-functions

# TODO  Check/install desired CentOS/Debian/Fedora/Ubuntu packages?


# Link to system git bash completion script (if installed)
if [ -r /usr/share/bash-completion/completions/git ]
then
    mklink /usr/share/bash-completion/completions/git ~/.git-completion.bash
fi

mklink $PWD/inputrc             ~/.inputrc
mklink $PWD/mybashrc            ~/.mybashrc
mklink $PWD/gitconfig           ~/.gitconfig
mklink $PWD/gitexcludes         ~/.gitexcludes
mklink $PWD/vimrc               ~/.vimrc
mklink $PWD/unix-vimrc          ~/.unix_vimrc
mklink $PWD/gvimrc              ~/.gvimrc

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

# Vim/Neovim stuff

# Install vim-plug  https://github.com/junegunn/vim-plug
if [ ! -r ~/.vim/autoload/plug.vim ]
then
    echo "Downloading vim-plug for Vim"
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi
if [ -n `which nvim` ]
then
    mklink $PWD/unix-vimrc  ~/.config/nvim/init.vim
    if [ ! -r ~/.local/share/nvim/site/autoload/plug.vim ]
    then
        echo "Downloading vim-plug for Neovim"
        curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    fi
fi

# TODO  X11/GUI desktop stuff

# .fonts directory contents
# Update system/user fontlist

# SSH configuration?
