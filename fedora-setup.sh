#!/usr/bin/env bash

# NOTE: This is intended to be run just once
# Additional Fedora-specific [Linux] configuration

# Prompt user and don't quit until we get a [non-empty] repsonse
# Returns lowercase version of whatever they typed in $response
user_prompt() {
    local prompt=$1                     # prompt text
    local userinput

    # Endlessly prompt until user enters something
    while [[ -z "$userinput" ]]
    do
        read -p "$prompt" userinput
    done
    response=$(echo $userinput | tr A-Z a-z)
}


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

    perl-CPAN
"

# Repository setup, then RPMs/RPM groups

# From  https://rpmfusion.org/Configuration#Command_Line_Setup_using_rpm
sudo dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

sudo dnf group install -y 'Development Tools'  'C Development Tools and Libraries'
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

# TODO  https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/CodeNewRoman ?
# TODO  https://kabeech.github.io/serious-sans/ , specifically https://kabeech.github.io/serious-sans/SeriousSans/otf/SeriousSansNerd.otf

# Update system/user fontlist
fc-cache

# Perl setup.  Install App::cpanminus w/ cpan, then perlbrew (via cpanm)
cpan App::cpanminus
cpanm --sudo App::perlbrew

# Optional [Full] desktop setup: more applications (RPMs) and conveniences
# XXX  As of Fedora 38, qqc2-desktop-style is required by ksnip but not included in the existing RPM?
more_rpms="
    terminus-fonts
    cascadia-code-pl-fonts

    gnome-tweaks
    fonts-tweak-tool
    kitty
    tilix
    chromium
    gimp
    remmina
    keepassxc
    ksnip
    qqc2-desktop-style

    i3
    i3status
    dmenu
    i3lock
    feh
    conky
"

compact=$(echo $more_rpms | sed 's/\s+/ /g;')
echo "Do you want to install the rest of the GUI apps?  $compact"
user_prompt 'Type "yes" to install, or anything else to skip [besides Enter]: '

if [[ "$response" == 'yes' ]]
then
    sudo dnf install -y $more_rpms
fi

echo "Do you want to install VSCode and Chrome?"

user_prompt 'Type "yes" to install, or anything else to skip [besides Enter]: '
if [[ "$response" == 'yes' ]]
then
    # Copied directly from  https://code.visualstudio.com/docs/setup/linux#_rhel-fedora-and-centos-based-distributions
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

    # Add Google Chrome [repository]
    # From https://docs.fedoraproject.org/en-US/quick-docs/installing-chromium-or-google-chrome-browsers/
    sudo dnf config-manager --set-enabled google-chrome

    # Add "code" RPM to the to-be-installed RPM list.  Will probably need to `dnf check-update` first
    sudo dnf check-update

    # Install VSCode and Chrome
     sudo dnf install -y code google-chrome-stable
fi

# Ask/confirm, re: need to SSH into box
echo "Do you want to setup SSH access to this machine?"
user_prompt 'Type "yes" to setup SSH, or anything else to skip [besides Enter]: '
if [[ "$response" == 'yes' ]]
then
    # Ensure SSH daemon is setup
    sudo systemctl start sshd.service
    sudo systemctl enable sshd.service
fi

# TODO  GUI keyboard shortcuts for terminal(s)
