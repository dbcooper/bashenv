# You may need to enable powershell scripts before running this
# program.  In a Powershell window w/ Administrator rights, run:
#
#    Set-ExecutionPolicy RemoteSigned
#
# Or maybe:
#
#    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process
#

# Allow for HOMEDRIVE, HOMEPATH changes due to network mount/AD directive
$my_home        = "$Env:HOMEDRIVE$Env:HOMEPATH"

$autoload_path  = "$my_home\.vim\autoload"
$plug_file      = "$autoload_path\plug.vim"
# Have to put configuration all vim-plug stuff in .vimrc:
# https://github.com/junegunn/vim-plug/issues/540#issuecomment-254580340

# Git bash windows mapping
$vimrc_file     = "$my_home\.vimrc"
$gvimrc_file    = "$my_home\.gvimrc"
$gitconfig_file = "$my_home\.gitconfig"
$bashrc_file    = "$my_home\.bashrc"

# Windows Vim configuration file mappings
$win_vimrc_file = "$my_home\_vimrc"
$win_gvimrc_file = "$my_home\_gvimrc"

# Install vimplug support  https://github.com/junegunn/vim-plug#windows-powershell
If ( !(Test-Path $plug_file) ) {
    If ( !(Test-Path $autoload_path) ) {
        md $autoload_path
    }
    Write-Output "Downloading vim-plug to $plug_file"
    $uri = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    (New-Object Net.WebClient).DownloadFile(
        $uri,
        $plug_file
    )
}

# TODO  Change tests to check latest modified time and copy over if repo version is newer
If ( !(Test-Path $bashrc_file) ) {
    Copy-Item windows-bashrc -Destination $bashrc_file
}
Else {
    # Only copy over file if newer
    xcopy windows-bashrc $bashrc_file /D
}

# Git bash vim setup
If ( !(Test-Path $vimrc_file) ) {
    Copy-Item unix-vimrc -Destination $vimrc_file
}
Else {
    # Only copy over file if newer?
    xcopy unix-vimrc $vimrc_file /D
}

If ( !(Test-Path $gvimrc_file) ) {
    Copy-Item windows-gvimrc -Destination $gvimrc_file
}
Else {
    # Only copy over file if newer?
    xcopy windows-gvimrc $gvimrc_file /D
}

# Windows-specific gvim file setup
If ( !(Test-Path $win_vimrc_file) ) {
    Copy-Item unix-vimrc -Destination $win_vimrc_file
}
Else {
    # Only copy over file if newer?
    xcopy unix-vimrc $win_vimrc_file /D
}

If ( !(Test-Path $win_gvimrc_file) ) {
    Copy-Item windows-gvimrc -Destination $win_gvimrc_file
}
Else {
    # Only copy over file if newer?
    xcopy windows-gvimrc $win_gvimrc_file /D
}

Write-Host @"

In the git bash shell, start vim and run :PlugInstall.  After that, plugins _should_ work properly in Windows gvim as well.

If you haven't already, you will need to install Python on the system for proper Vim (plugin) support.  You will need to install the appropriate Python version for whatever version gVim you're using was compiled against.

E.g., gvim 8.0 32-bit was compiled against Python 3.5 so I did the following to get it to work:
  - I _think_ only the major and minor version number matter (i.e., ignore patch)
  - Download Python 3.5.4rc1 32-bit, < https://www.python.org/downloads/release/python-354rc1/ >
  - Install Python 3.5 in c:\Python\Python35-32   # Idk if directory matters
  - Copy python35.dll to the gvim 8.0 install directory, C:\Program Files (x86)\Vim\vim80

FMI
  - https://stackoverflow.com/a/17963884
  - https://www.reddit.com/r/vim/comments/671c5u/vim_python_install_help/

"@

If ( !(Test-Path $gitconfig_file) ) {
    Copy-Item gitconfig -Destination $gitconfig_file
}
Else {
    # Only copy over file if newer?
    xcopy gitconfig $gitconfig_file /D
}


# XXX  I briefly looked to Neovim for binary-compatible Vi
# However, I noticed recently (~June 2025) they started building Vim [nightlies] for Windows ARM64 (Aarch64) :)

# Neovim + QT gui
# XXX  _May_ need to install the following manually if on Arm64 silicon?  neovim has a hardcoded x86_64 MS VC redistributable
#winget install microsoft.vcredist.2015+.arm64
#winget install neovim.neovim
#winget install equalsraf.neovim-qt

winget install rclone.rclone

#  Install Python for Vi scripting.  Supposedly Python 3.8 or later, Python 3.12 should be good to 2028-10
# https://www.python.org/downloads/
winget install python.python.3.12

# Install Gimp 3
winget install gimp.gimp.3
