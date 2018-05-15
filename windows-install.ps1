# You may need to enable powershell scripts before running this
# program.  In a Powershell window w/ Administrator rights, run:
#
#    Set-ExecutionPolicy RemoteSigned
#

# Apparently $HOME is set as well (and case insensitive?).  ~ works too?
$autoload_path  = "$HOME\vimfiles\autoload"
$plug_file      = "$autoload_path\plug.vim"
$vimrc_file     = "$HOME\.unix_vimrc"
$gvimrc_file    = "$HOME\.gvimrc"
$gitconfig_file = "$HOME\.gitconfig"

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

If ( !(Test-Path $vimrc_file) ) {
    Copy-Item unix-vimrc -Destination $vimrc_file
}

If ( !(Test-Path $gvimrc_file) ) {
    Copy-Item windows-gvimrc -Destination $gvimrc_file
}

Write-Output "You'll need to start gvim.exe and run :PlugInstall from git bash, probably."

If ( !(Test-Path $gitconfig_file) ) {
    Copy-Item gitconfig -Destination $gitconfig_file
}

