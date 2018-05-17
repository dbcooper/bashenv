#!/usr/bin/env bash

# TODO  Test for sudo/root privileges?

# Just trying to cover Fedora 27/28 (for now), assuming desktop/workstation
fedora_rpms="
    ack

    vim-common
    vim-enhanced
    vim-filesystem
    vim-perl-support
    vim-taglist
    vim-X11
    neovim

    powerline
    powerline-fonts
    tmux-powerline
    powerline-docs

    terminus-fonts
    bitmap-console-fonts
"

# Repository setup, then RPMs

# From  https://rpmfusion.org/Configuration#Command_Line_Setup_using_rpm
dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

dnf install $fedora_rpms

