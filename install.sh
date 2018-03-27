#!/bin/bash

source ./install-functions

# TODO  Check/install desired CentOS/Debian/Fedora/Ubuntu packages?

# awk
# vim packages

# Optional: powerline, neovim

# Locate system git bash completion script (if installed)
git_completion=/usr/share/bash-completion/completions/git
git_prompt=
if [ ! -r $git_completion ]
then
    if [ -n "`which git 2>/dev/null`" ]
    then
        # Assuming RHEL-based distro, path will vary
        git_completion=`rpm -q -l git | grep -i 'git-completion\.bash'`
        git_prompt=`rpm -q -l git | grep -i '/usr/share/doc/.*/git-prompt\.sh'`
    else
        git_completion=
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

mklink $PWD/inputrc             ~/.inputrc
mklink $PWD/mybashrc            ~/.mybashrc
mklink $PWD/gitconfig           ~/.gitconfig
mklink $PWD/gitexcludes         ~/.gitexcludes
mklink $PWD/vimrc               ~/.vimrc
mklink $PWD/unix-vimrc          ~/.unix_vimrc
mklink $PWD/gvimrc              ~/.gvimrc
mklink $PWD/tmux.conf           ~/.tmux.conf

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
    echo "?No .bashrc file in $HOME, unsure how to proceed"
    # TODO  Create simple .bashrc?
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

# TODO  X11/GUI desktop stuff ?

# .fonts directory contents
# Update system/user fontlist

# TODO  SSH configuration?  For gateway systems only?

# Common little utilities
mkdir -p ~/bin
mklink $PWD/plcln.sh                ~/bin/plcln
mklink $PWD/clean-powerline.sed     ~/bin/clean-powerline.sed
