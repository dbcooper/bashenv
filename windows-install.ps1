# You may need to enable powershell scripts before running this
# program.  In a Powershell window w/ Administrator rights, run:
#
#    Set-ExecutionPolicy RemoteSigned
#

# Allow for HOMEDRIVE, HOMEPATH changes due to network mount/AD directive
$my_home        = "$Env:HOMEDRIVE$Env:HOMEPATH"

$autoload_path  = "$my_home\vimfiles\autoload"
$plug_file      = "$autoload_path\plug.vim"
$vimrc_file     = "$my_home\.unix_vimrc"
$gvimrc_file    = "$my_home\.gvimrc"
$gitconfig_file = "$my_home\.gitconfig"

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

