#!/usr/bin/env bash

# This is intended to be run just once

fedora_rpms="
    ack
    htop

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
sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

sudo dnf install $fedora_rpms

# Install monaco font from https://github.com/inoyatov/monaco
# XXX  This installs the font but I can't select it in gnome-terminal anyway :\
font_fn=Ubuntu_Mono_derivative_Powerline.ttf
curl -L --output $font_fn  https://github.com/inoyatov/monaco/raw/master/font/Ubuntu%20Mono%20derivative%20Powerline.ttf
mkdir -p ~/.fonts
mv $font_fn ~/.fonts

symbols_fn=10-powerline-symbols.conf
mkdir -p ~/.config/fontconfig/conf.d/
curl -L --output $symbols_fn  https://raw.githubusercontent.com/inoyatov/monaco/master/config/10-powerline-symbols.conf
mv $symbols_fn ~/.config/fontconfig/conf.d/

fc-cache

# TODO  Prompt for confirmation before doing the following (default: No)

# Optional [Full] desktop setup: more applications (RPMs) and conveniences
more_rpms="
    gnome-tweaks
    fonts-tweak-tool
    tilix
    chromium
    gimp
"

# If want VSCode:
#   *  Add VSCode repository

# Copied directly from  https://code.visualstudio.com/docs/setup/linux#_rhel-fedora-and-centos-based-distributions
##sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
##sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

#   *  Add "code" to the to-be-installed RPM list.  Will probably need to `dnf check-update` first

# Google Chrome - automate install?

