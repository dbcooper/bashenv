#!/bin/bash

source ./install-functions

# TODO  Check/install desired CentOS/Debian/Fedora/Ubuntu packages?

# awk
# vim packages

# Optional: powerline, neovim

# Assume if the RPM program is installed, it's RHEL/CentOS/Fedora
HAS_RPM=`which rpm`

# System's git bash completion scripts (if installed)
git_completion=
git_prompt=
if [ -n "`which git 2>/dev/null`" ]
then
    if [ -n "$HAS_RPM" ]
    then
        # On redhat-based distros, path will vary
        git_completion=`rpm -q -l git | grep -i 'git-completion\.bash$'`
        git_prompt=`rpm -q -l git git-core | grep -i 'git-prompt\.sh$'`
    elif [ -r '/usr/share/bash-completion/completions/git' ]
    then
        git_completion='/usr/share/bash-completion/completions/git'
    # TODO  Add test/FQPN resolution for Debian-based distributions
    else
        echo "?don't know how to locate Bash helper scripts for git on this OS"
    fi
fi

# Kluge!  Workaround for Gentoo's git
if [[ -r $git_completion && ! -r $git_prompt ]]
then
    if [ -r '/usr/share/git/git-prompt.sh' ]
    then
        git_prompt=/usr/share/git/git-prompt.sh
    fi
fi

# Link it
if [ -r "$git_completion" ]
then
    mklink $git_completion  ~/.git-completion.bash
fi

# Had to do this on one CentOS 7 install but not sure why .git-completion.bash
# was not enough
if [[ "$git_prompt" && -r "$git_prompt" ]]
then
    mklink $git_prompt ~/.git-prompt.sh
fi

# Determine tmux version, use appropriate syntax
tmux_conf=$PWD/tmux.conf
if [ -n "`which tmux 2>/dev/null`" ]
then
    TMUX_MAJOR=`tmux -V | sed -r 's/(^tmux |\.[0-9]+.*$)//g;'`
    if [ "$TMUX_MAJOR" -gt 1 ]
    then
        tmux_conf=$PWD/tmux-2.conf
    fi
fi

mklink $PWD/inputrc             ~/.inputrc
mklink $PWD/mybashrc            ~/.mybashrc
mklink $PWD/gitconfig           ~/.gitconfig
mklink $PWD/gitexcludes         ~/.gitexcludes
mklink $PWD/vimrc               ~/.vimrc
mklink $PWD/unix-vimrc          ~/.unix_vimrc
mklink $PWD/gvimrc              ~/.gvimrc
mklink $tmux_conf               ~/.tmux.conf

# Powerline
if [ -n "`which powerline 2>/dev/null`" ]
then
    mkdir -p ~/.config/powerline
    mklink $PWD/powerline_config.json  ~/.config/powerline/config.json
    pb_source='/usr/share/powerline/bash/powerline.sh'
    if [ ! -r $pb_source ]
    then
        if [ -r '/usr/share/powerline/bindings/bash/powerline.sh' ]
        then
            # Ubuntu 16
            pb_source='/usr/share/powerline/bindings/bash/powerline.sh'
        else
            # Adapt to pip-installed powerline
            pip_path=`pip show powerline-status 2>/dev/null | grep -oP '(?<=Location: )(.*)$'`
            pb_source="$pip_path/powerline/bindings/bash/powerline.sh"
        fi
    fi
    mklink $pb_source  ~/.powerline_bindings.sh
fi

# Load our bash magic on login
if [ -r ~/.bashrc ]
then
    append ~/.bashrc bash-append
else
    echo "?No existing .bashrc file in $HOME, creating simple version"
    cp bash-append ~/.bashrc
fi

# Vim/Neovim

# Install vim-plug  https://github.com/junegunn/vim-plug
if [ ! -r ~/.vim/autoload/plug.vim ]
then
    echo "Downloading vim-plug for Vim"
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi
if [ -n "`which nvim 2>/dev/null`" ]
then
    mkdir -p ~/.config/nvim
    mklink $PWD/unix-vimrc  ~/.config/nvim/init.vim
    if [ ! -r ~/.local/share/nvim/site/autoload/plug.vim ]
    then
        echo "Downloading vim-plug for Neovim"
        curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    fi
fi

# TODO  SSH configuration?  For gateway systems only?

# Common little utilities
mkdir -p ~/bin
mklink $PWD/plcln.sh                ~/bin/plcln
mklink $PWD/clean-powerline.sed     ~/bin/clean-powerline.sed
mklink $PWD/moshkey.sh              ~/bin/moshkey
mklink $PWD/tmuxgo                  ~/bin/tmuxgo

# [Common] X11/GUI desktop stuff

# i3 and urxvt
if [ -n "`which i3 2>/dev/null`" ]
then
    mkdir -p ~/.config/i3
    mklink $PWD/Xresources      ~/.Xresources
    mklink $PWD/i3-config       ~/.config/i3/config
fi

# XXX  For .fonts directory contents, see fedora-setup

