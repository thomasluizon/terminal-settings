# Terminal Settings

A complete setup for a modern, beautiful PowerShell terminal with Oh My Posh, icons, fuzzy finding, and more.

## Prerequisites

Install the latest version of PowerShell:

```powershell
winget install --id Microsoft.PowerShell --source winget
```

After installation, **restart your terminal** and use PowerShell 7+ for all subsequent commands.

## Quick Installation

Run all commands below in PowerShell (as Administrator recommended):

### 1. Install Core Tools

```powershell
# Install Scoop (package manager)
irm get.scoop.sh -outfile 'install.ps1'
.\install.ps1 -RunAsAdmin
Remove-Item 'install.ps1'

# Install Oh My Posh
winget install JanDeDobbeleer.OhMyPosh -s winget

# Install fzf (fuzzy finder)
scoop install fzf
```

### 2. Install PowerShell Modules

```powershell
Install-Module -Name Terminal-Icons -Repository PSGallery -Force
Install-Module -Name z -Force
Install-Module -Name PSFzf -Scope CurrentUser -Force
Install-Module -Name PSReadLine -Force -SkipPublisherCheck
```

### 3. Install Nerd Font

```powershell
# Add nerd-fonts bucket (if not already added)
scoop bucket add nerd-fonts

# Install the JetBrains Mono Nerd Font
scoop install JetBrainsMono-NF
```

After installation, set the font in Windows Terminal:
1. Open Windows Terminal Settings (Ctrl+,)
2. Go to Profiles → Defaults → Appearance
3. Set Font face to "JetBrainsMono Nerd Font"

### 4. Setup Configuration Files

```powershell
# Clone or download this repo, then navigate to it
cd path\to\terminal-settings

# Copy PowerShell profile
$profileDir = Split-Path $PROFILE
if (!(Test-Path $profileDir)) { New-Item -Path $profileDir -ItemType Directory -Force }
Copy-Item -Path "Files\Microsoft.PowerShell_profile.ps1" -Destination $PROFILE -Force

# Copy Oh My Posh theme
Copy-Item -Path "Files\clean-detailed.omp.json" -Destination $profileDir -Force

# Copy Windows Terminal settings (backup your current settings first!)
$wtSettingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
Copy-Item -Path "Files\settings.json" -Destination $wtSettingsPath -Force
```

### 5. (Optional) Set Environment Variable for Custom Theme

If you want to use a different Oh My Posh theme:

```powershell
[System.Environment]::SetEnvironmentVariable('OH_MY_POSH_THEME', 'C:\path\to\your\theme.omp.json', 'User')
```

Otherwise, the profile will use the included `clean-detailed.omp.json` theme automatically.

## What's Included

- **Oh My Posh**: Beautiful prompt with git status, system info, and execution time
- **Terminal Icons**: Colorful file/folder icons in directory listings
- **PSReadLine**: Enhanced command-line editing with history search
- **PSFzf**: Fuzzy finding for files and command history (Ctrl+F, Ctrl+R)
- **z**: Quick directory jumping based on frecency
- **Custom aliases**:
  - `vim`, `v` → nvim
  - `touch`, `ll` → Unix-like commands
  - `which` → Find command path
  - `claude` → Claude Code with auto-skip permissions
  - `copilot` → GitHub Copilot CLI wrapper

## Features

- Tab completion with menu
- Up/Down arrow for command history search
- Prediction suggestions from history
- Standard clipboard shortcuts: **Ctrl+C** (copy), **Ctrl+V** (paste), **Ctrl+X** (cut), **Ctrl+A** (select all)
- Acrylic transparency effect
- Custom color scheme (One Half Dark modded)
- Git integration in prompt

## Troubleshooting

**CONFIG ERROR on startup?**
The Oh My Posh theme file is missing. Copy it to your profile directory:
```powershell
$profileDir = Split-Path $PROFILE
Copy-Item -Path "Files\clean-detailed.omp.json" -Destination $profileDir -Force
```

**Script execution policy error?**
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

**Oh My Posh not found?**
Restart your terminal after installation or add to PATH manually.

**Font not rendering correctly?**
Make sure you installed a Nerd Font and set it in Windows Terminal settings.

**PSReadLine virtual terminal error?**
This is a warning when running PowerShell through certain contexts (like git bash or redirected output). It's safe to ignore or disable that specific option in the profile.

## Reference

Based on [this video tutorial](https://www.youtube.com/watch?v=5-aK2_WwrmM) with improvements for easier installation.
