# You may need to enable powershell scripts before running this
# program.  In a Powershell window w/ Administrator rights, run:
#
#    Set-ExecutionPolicy RemoteSigned
#

# Allow for HOMEDRIVE, HOMEPATH changes due to network mount/AD directive
$my_home        = "$Env:HOMEDRIVE$Env:HOMEPATH"

$autoload_path  = "$my_home\vimfiles\autoload"
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

# Git bash vim setup
If ( !(Test-Path $vimrc_file) ) {
    Copy-Item unix-vimrc -Destination $vimrc_file
}
If ( !(Test-Path $gvimrc_file) ) {
    Copy-Item windows-gvimrc -Destination $gvimrc_file
}

# Windows-specific gvim file setup
If ( !(Test-Path $win_vimrc_file) ) {
    Copy-Item unix-vimrc -Destination $win_vimrc_file
}
If ( !(Test-Path $win_gvimrc_file) ) {
    Copy-Item windows-gvimrc -Destination $win_gvimrc_file
}

Write-Output "In the git bash shell, start vim and run :PlugInstall.  After that, plugins _should_ work properly in Windows gvim as well."

If ( !(Test-Path $gitconfig_file) ) {
    Copy-Item gitconfig -Destination $gitconfig_file
}
