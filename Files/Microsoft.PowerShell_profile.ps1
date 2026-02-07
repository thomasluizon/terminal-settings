# Oh My Posh initialization - using environment variable or default theme
if ($env:OH_MY_POSH_THEME) {
    $ohMyPoshTheme = $env:OH_MY_POSH_THEME
} elseif (Test-Path "$PSScriptRoot\clean-detailed.omp.json") {
    $ohMyPoshTheme = "$PSScriptRoot\clean-detailed.omp.json"
} else {
    # Fallback to a built-in theme
    $ohMyPoshTheme = "$env:POSH_THEMES_PATH\clean-detailed.omp.json"
}

if (Test-Path $ohMyPoshTheme) {
    oh-my-posh init pwsh --config $ohMyPoshTheme | Invoke-Expression
} else {
    Write-Host "Warning: Oh My Posh theme not found at $ohMyPoshTheme" -ForegroundColor Yellow
}

# Import modules only if available (faster startup)
$modules = @('Terminal-Icons', 'PSFzf', 'PSReadLine')
foreach ($module in $modules) {
    if (Get-Module -ListAvailable -Name $module) {
        Import-Module $module -ErrorAction SilentlyContinue
    }
}

# PSReadLine configuration (only if module is loaded)
if (Get-Module -Name PSReadLine) {
    Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
    Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
    Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
    Set-PSReadLineOption -HistorySearchCursorMovesToEnd
    Set-PSReadLineOption -ShowToolTips
    Set-PSReadLineOption -PredictionSource History

    # Standard clipboard keybindings (Ctrl+X, Ctrl+A, Ctrl+V)
    Set-PSReadLineKeyHandler -Chord "Ctrl+v" -Function Paste
    Set-PSReadLineKeyHandler -Chord "Ctrl+c" -Function Copy
    Set-PSReadLineKeyHandler -Chord "Ctrl+x" -Function Cut
    Set-PSReadLineKeyHandler -Chord "Ctrl+a" -Function SelectAll
}

# PSFzf configuration (only if module is loaded)
if (Get-Module -Name PSFzf) {
    Set-PSFzfOption -PSReadlineChordProvider 'Ctrl+f' -PSReadlineChordReverseHistory 'Ctrl+r'
}

# Aliases (only create if commands exist)
if (Get-Command nvim -ErrorAction SilentlyContinue) {
    Set-Alias -Name vim -Value nvim -Force
    Set-Alias -Name v -Value nvim -Force
}

# Utility aliases
Set-Alias -Name touch -Value New-Item -Force
Set-Alias -Name ll -Value Get-ChildItem -Force

# Unix-like 'which' command
function which ($command) {
    Get-Command -Name $command -ErrorAction SilentlyContinue |
        Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}

# Claude Code alias with skip permissions
function claude {
    & claude.exe --dangerously-skip-permissions $args
}

# GitHub Copilot CLI alias with brave mode
function copilot {
    & copilot.exe --execute $args
}

# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
    Import-Module "$ChocolateyProfile"
}
