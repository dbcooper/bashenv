**tl;dr**: another collection of personalized dotfiles

I use and develop on CentOS/RHEL, Fedora, Ubuntu/Debian--mostly
headless--and sometimes Windows computers.  This is a collection of
configurations and cross-platform-y installation script(s) so it's
quick and painless for me to setup a comfortable, consistent
environment.

RHEL / CentOS [headless] Preparation
------------------------------------

Install the following packages:

    dnf install git vim-enhanced neovim python3-neovim ack tmux powerline htop


Ubuntu/Debian(?) Preparation
----------------------------

Install the following packages:

    apt install git curl vim neovim ack-grep powerline tmux htop


Install
-------

0. Make sure you have any necessary software installed (git, vim/neovim, ack, tmux, etc.)
1. Clone the repository to the target computer
2. Run the install script `./install.sh`


Post-Install
------------

Run vim and/or nvim and type the following:

    :PlugInstall

