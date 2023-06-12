#!/usr/bin/env bash

# This is intended to be run just once

fedora_rpms="
    ack
    htop
    cloc
    keychain

    vim-common
    vim-enhanced
    vim-filesystem
    vim-perl-support
    vim-taglist
    vim-X11
    neovim
    python3-neovim

    powerline
    powerline-fonts
    tmux-powerline
    powerline-docs

    terminus-fonts
    cascadia-code-pl-fonts

    perl-CPAN
"

# Repository setup, then RPMs/RPM groups

# From  https://rpmfusion.org/Configuration#Command_Line_Setup_using_rpm
sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

sudo dnf group install 'Development Tools'  'C Development Tools and Libraries'
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

# Update system/user fontlist
fc-cache

# Perl setup.  Install App::cpanminus w/ cpan, then perlbrew (via cpanm)
cpan App::cpanminus
cpanm --sudo App::perlbrew


# TODO  Prompt for confirmation before doing the following (default: No)

# Optional [Full] desktop setup: more applications (RPMs) and conveniences
more_rpms="
    gnome-tweaks
    fonts-tweak-tool
    tilix
    chromium
    gimp
    remmina
    keepassxc

    i3
    i3status
    dmenu
    i3lock
    feh
    conky
"

# If want VSCode:
#   *  Add VSCode repository
#
# Copied directly from  https://code.visualstudio.com/docs/setup/linux#_rhel-fedora-and-centos-based-distributions
##sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
##sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
#
#   *  Add "code" RPM to the to-be-installed RPM list.  Will probably need to `dnf check-update` first

# TODO  Install additional RPMs

# Google Chrome - automate install?

# TODO  Ask/confirm, re: need to SSH into box
# Ensure SSH daemon is setup
#sudo systemctl start sshd.service
#sudo systemctl enable sshd.service

# TODO  GUI keyboard shortcuts for terminal(s)
