#!/usr/bin/env bash

# NOTE: This is intended to be run just once
# Additional Fedora-specific [Linux] configuration

MY_FONTS=$HOME/.local/share/fonts

# Prompt user and don't quit until we get a [non-empty] repsonse
# Returns lowercase version of whatever they typed in $response
function user_prompt() {
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
    the_silver_searcher
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
    needrestart
"

# Repository setup, then RPMs/RPM groups

# From  https://rpmfusion.org/Configuration#Command_Line_Setup_using_rpm
sudo dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# XXX  Support Fedora 44 naming?
sudo dnf group install -y 'development-tools'  'c-development'
sudo dnf install $fedora_rpms

# Install monaco font from https://github.com/inoyatov/monaco
# XXX  This installs the font but I can't select it in gnome-terminal anyway :\
font_fn=Ubuntu_Mono_derivative_Powerline.ttf
curl -L --output $font_fn  https://github.com/inoyatov/monaco/raw/master/font/Ubuntu%20Mono%20derivative%20Powerline.ttf
mkdir -p $MY_FONTS
mv $font_fn $MY_FONTS

symbols_fn=10-powerline-symbols.conf
mkdir -p ~/.config/fontconfig/conf.d/
curl -L --output $symbols_fn  https://raw.githubusercontent.com/inoyatov/monaco/master/config/10-powerline-symbols.conf
mv $symbols_fn ~/.config/fontconfig/conf.d/

# TODO  https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/CodeNewRoman ?
# TODO  https://kabeech.github.io/serious-sans/ , specifically https://kabeech.github.io/serious-sans/SeriousSans/otf/SeriousSansNerd.otf

# Update system/user fontlist
fc-cache

# Perl setup.  Install App::cpanminus w/ cpan, then perlbrew (via cpanm)
sudo cpan App::cpanminus
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
    sudo dnf config-manager enable google-chrome

    # Add "code" RPM to the to-be-installed RPM list.  Will probably need to `dnf check-update` first
    sudo dnf check-update

    # Install VSCode and Chrome
     sudo dnf install -y code google-chrome-stable
fi


# Perform environment check / setup for SSHD support
function sshd_setup() {
    # XXX  Workaround/solution for gnome-keyring nuking SSH agent forwarding on Fedora 43/44
    # I don't think this works/solves the issue, but a related thing I _can_ do.
    systemctl --user mask gnome-keyring-daemon.service gnome-keyring-daemon.socket

    # Ensure sshd supports for environment variables
    user_env=$(sudo sshd -T | grep -i 'permituserenvironment')
    if [[ -z "$user_env" ]]
    then
        echo "? ⚠️ Didn't detect 'permituserenvironment' in sshd configuration? ⚠️ "
    else
        # Verify permituserenvironment is enabled (yes)
        ue_state=$(echo "$user_env" | awk '{ print $2; }' | tr '[:upper:]' '[:lower:]')
        if [[ "$ue_state" != 'yes' ]]
        then
            # Which file contains the PermitUserEnvironment declaration?
            conf_file=$(sudo grep -l -R -i 'permituserenvironment' /etc/ssh/sshd_config /etc/ssh/sshd_config.d/)
            echo " 🛑  WARNING: SSHD configuration does _not_ have PermitUserEnvironment enabled (yes).  🛑 "
            if [[ -n "$conf_file" ]]
            then
                echo -e "\nPermitUserEnvironment declaration/reference(s) appear in: $conf_file"
            fi
            echo -e "\n👉  Edit your sshd configuration (should be underneath /etc/ssh/) and add the following line to the $conf_file file: 👈"
            echo -e "\nPermitUserEnvironment yes\n"
        fi
    fi
}

# Ask/confirm, re: need to SSH into box
echo "Do you want to setup SSH access to this machine?"
user_prompt 'Type "yes" to setup SSH, or anything else to skip [besides Enter]: '
if [[ "$response" == 'yes' ]]
then
    # Ensure SSH daemon is setup
    sudo systemctl start sshd.service
    sudo systemctl enable sshd.service
    sshd_setup
fi


# TODO  GUI keyboard shortcuts for terminal(s)
