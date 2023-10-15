# My Terminal Settings

![GitHub](https://img.shields.io/github/license/thomasluizon/terminal-settings)

# Windows Terminal

1. Install scoop - `irm get.scoop.sh | iex`
2. Install fonts
3. Copy settings.json content to your windows terminal settings.json
4. Install oh my posh - `scoop install https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/oh-my-posh.json`

## PowerShell

1. Install powershell and update
2. run these commands:
   `Install-Module -Name Terminal-Icons -Repository PSGallery -Force`
   `Install-Module -Name z -Force`
   `scoop install fzf`
   `Install-Module -Name PSFzf -Scope CurrentUser -Force`
3. write $PROFILE on powershell and move Microsoft.PowerShel_profile.ps1 to the directory

## Oh My Posh

1. move clean-detailed.omp.json to the directory on the powershell file

-  https://www.youtube.com/watch?v=5-aK2_WwrmM
