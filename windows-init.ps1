
# This script is intended to be run only _once_ for a [new] Windows system setup

# The goal is to provide a minimal bootstrap/setup in order to get to where bashenv repository can be cloned and script(s) in there utilized


# TODO  Check for sentinel file presence, if so, exit.

# Want/need Git Bash
winget install git.git

# XXX  I _think_ MS Terminal and OpenSSH (sufficient version) are already installed?  At least in Windows 11
#winget install microsoft.windowsterminal
# XXX  Did Windows OpenSSH people s/beta/preview/ ?
#winget install microsoft.openssh.beta --override ADDLOCAL=Client
#winget install microsoft.openssh.preview --override ADDLOCAL=Client

# Generate elliptic SSH public key
# Accept default location but set password when prompted
Write-Output "Generating Elliptical SSH key.  Accept default location but set a key password when prompted.`n"
ssh-keygen -t ed25519 

# SSH Agent authentication
# XXX  Might have to run this in administrator PowerShell?
Write-Output "Copy the following SSH key information to your preferred .ssh/authorized_keys file(s):`n"
get-service ssh-agent | set-service -StartupType automatic
Start-Service ssh-agent

# TODO  Empty prompt for user to run the above service commands in administrator-level shell?

Write-Output "Copy the following SSH key information to your preferred .ssh/authorized_keys file(s):`n"
type $env:USERPROFILE\.ssh\id_ed25519.pub
Write-Output "`n"

Write-Output "Adding Elliptical SSH public key to the SSH agent.  Enter your password when prompted.`n"
ssh-add $env:USERPROFILE\.ssh\id_ed25519

# TODO  Touch sentinel file

Write-Output "👉 If everything ran OK, now execute .\windows-install.ps1`n"
