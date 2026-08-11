# Terminal Settings

A complete setup for a modern, beautiful PowerShell terminal with Oh My Posh, icons, fuzzy finding, and more.

## Quick Installation

Everything below installs per-user and needs **no administrator rights**. Start in whatever
PowerShell you have (Windows PowerShell 5.1 is fine) — step 2 installs PowerShell 7, and from
step 3 onward you run commands **in PowerShell 7 (`pwsh`)**.

### 1. Install Scoop

```powershell
irm get.scoop.sh | iex
```

> Do **not** run this from an elevated prompt. Scoop is designed to install per-user; if you are
> already in an admin session, use `irm get.scoop.sh -outfile 'install.ps1'; .\install.ps1 -RunAsAdmin`
> instead.

Scoop adds `~\scoop\shims` to your user `PATH`. **Open a new terminal** so the change takes effect.

### 2. Install Core Tools

```powershell
scoop install pwsh oh-my-posh fzf
```

Now **close this terminal and open PowerShell 7** (`pwsh`) for the remaining steps, so modules and
the profile land in PowerShell 7's paths rather than Windows PowerShell's.

<details>
<summary>Alternative: install PowerShell 7 and Oh My Posh with winget (requires admin/UAC)</summary>

```powershell
winget install --id Microsoft.PowerShell --source winget
winget install JanDeDobbeleer.OhMyPosh -s winget
scoop install fzf
```

</details>

### 3. Install PowerShell Modules

Run these **in `pwsh`**. `-Scope CurrentUser` keeps the install per-user; without it, PowerShell
targets the machine-wide folder and fails unless elevated.

```powershell
Install-Module -Name Terminal-Icons -Repository PSGallery -Scope CurrentUser -Force
Install-Module -Name z -Scope CurrentUser -Force
Install-Module -Name PSFzf -Scope CurrentUser -Force
Install-Module -Name PSReadLine -Scope CurrentUser -Force -SkipPublisherCheck
```

### 4. Install the Nerd Font

```powershell
scoop bucket add nerd-fonts
scoop install JetBrainsMono-NF-Mono
```

> **Install `JetBrainsMono-NF-Mono`, not `JetBrainsMono-NF`.** Both extract the same archive, but
> each registers a different subset: `-NF` registers only the proportional faces, while the included
> `settings.json` asks for the **`JetBrainsMonoNL Nerd Font Mono`** family, which only `-NF-Mono`
> registers. Install `JetBrainsMono-NF` as well if you also want the ligature/proportional variants.

You do not need to set the font by hand — step 5 copies a `settings.json` that already selects it.

### 5. Setup Configuration Files

```powershell
# Clone or download this repo, then navigate to it
cd path\to\terminal-settings

# Copy PowerShell profile + Oh My Posh theme (run this from pwsh, so $PROFILE
# resolves to ...\Documents\PowerShell\)
$profileDir = Split-Path $PROFILE
if (!(Test-Path $profileDir)) { New-Item -Path $profileDir -ItemType Directory -Force }
Copy-Item -Path "Files\Microsoft.PowerShell_profile.ps1" -Destination $PROFILE -Force
Copy-Item -Path "Files\clean-detailed.omp.json" -Destination $profileDir -Force

# Copy Windows Terminal settings, backing up the current ones first
$wtSettingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
Copy-Item -Path $wtSettingsPath -Destination "$wtSettingsPath.bak" -Force
Copy-Item -Path "Files\settings.json" -Destination $wtSettingsPath -Force
```

Restart Windows Terminal to pick up the new settings.

### 6. (Optional) Set Environment Variable for Custom Theme

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
  - `vim`, `v` → nvim (only registered when nvim is on `PATH`)
  - `touch`, `ll` → Unix-like commands
  - `which` → Find command path
  - `claude` → Claude Code with auto-skip permissions
  - `codex` → Codex CLI with approvals/sandbox bypass

## Features

- Tab completion with menu
- Up/Down arrow for command history search
- Prediction suggestions from history
- Standard clipboard shortcuts: **Ctrl+C** (copy), **Ctrl+V** (paste), **Ctrl+X** (cut), **Ctrl+A** (select all)
- Acrylic transparency effect
- Custom color scheme (One Half Dark modded)
- Git integration in prompt
- Lazy module loading and a cached Oh My Posh init, for sub-second startup

## Troubleshooting

**"Unable to find the selected font JetBrainsMonoNL Nerd Font Mono"?**
You installed `JetBrainsMono-NF` instead of `JetBrainsMono-NF-Mono`. Run
`scoop install JetBrainsMono-NF-Mono` and restart Windows Terminal. Note that Windows Terminal
resolves fonts by their full DirectWrite family name, which differs from the shortened name
(`JetBrainsMonoNL NFM`) shown by tools that enumerate GDI font names.

**Windows Terminal opens Windows PowerShell 5.1 instead of PowerShell 7?**
The `PowerShell` profile launches `pwsh.exe` from `PATH`. Confirm `pwsh` resolves
(`Get-Command pwsh`) and open a new terminal so a refreshed `PATH` is inherited.

**CONFIG ERROR on startup?**
The Oh My Posh theme file is missing. Copy it to your profile directory:
```powershell
$profileDir = Split-Path $PROFILE
Copy-Item -Path "Files\clean-detailed.omp.json" -Destination $profileDir -Force
```

**Profile changes seem to have no effect?**
Check you edited PowerShell 7's profile (`...\Documents\PowerShell\`) and not Windows
PowerShell's (`...\Documents\WindowsPowerShell\`). `pwsh -c '$PROFILE'` prints the right path.

**Script execution policy error?**
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

**Oh My Posh not found?**
Restart your terminal after installation or add to PATH manually.

**PSReadLine virtual terminal error?**
This is a warning when running PowerShell through certain contexts (like git bash or redirected output). It's safe to ignore or disable that specific option in the profile.

## Reference

Based on [this video tutorial](https://www.youtube.com/watch?v=5-aK2_WwrmM) with improvements for easier installation.
