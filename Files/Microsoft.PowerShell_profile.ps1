function Test-PSReadLinePredictionSupport {
    try {
        if ([Console]::IsOutputRedirected -or [Console]::IsInputRedirected) {
            return $false
        }
    } catch {
        return $false
    }

    $supportsVirtualTerminal = $false
    if ($Host.UI -and ($Host.UI | Get-Member -Name SupportsVirtualTerminal -MemberType Property -ErrorAction SilentlyContinue)) {
        $supportsVirtualTerminal = [bool]$Host.UI.SupportsVirtualTerminal
    }

    return $supportsVirtualTerminal
}

# Oh My Posh
if ($env:OH_MY_POSH_THEME) {
    $ohMyPoshTheme = $env:OH_MY_POSH_THEME
} elseif (Test-Path "$PSScriptRoot\clean-detailed.omp.json") {
    $ohMyPoshTheme = "$PSScriptRoot\clean-detailed.omp.json"
} else {
    $ohMyPoshTheme = "$env:POSH_THEMES_PATH\clean-detailed.omp.json"
}

if (Test-Path $ohMyPoshTheme) {
    oh-my-posh init pwsh --config $ohMyPoshTheme | Invoke-Expression
} else {
    Write-Host "Warning: Oh My Posh theme not found at $ohMyPoshTheme" -ForegroundColor Yellow
}

# Modules
$modules = @('Terminal-Icons', 'PSFzf', 'PSReadLine')
foreach ($module in $modules) {
    if (Get-Module -ListAvailable -Name $module) {
        Import-Module $module -ErrorAction SilentlyContinue
    }
}

# PSReadLine
if (Get-Module -Name PSReadLine) {
    Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
    Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
    Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
    Set-PSReadLineOption -HistorySearchCursorMovesToEnd
    Set-PSReadLineOption -ShowToolTips

    if (Test-PSReadLinePredictionSupport) {
        try {
            Set-PSReadLineOption -PredictionSource History -ErrorAction Stop
        } catch {
        }
    }

    Set-PSReadLineKeyHandler -Chord "Ctrl+v" -Function Paste
    Set-PSReadLineKeyHandler -Chord "Ctrl+c" -Function Copy
    Set-PSReadLineKeyHandler -Chord "Ctrl+x" -Function Cut
    Set-PSReadLineKeyHandler -Chord "Ctrl+a" -Function SelectAll
}

# PSFzf
if (Get-Module -Name PSFzf) {
    Set-PSFzfOption -PSReadlineChordProvider 'Ctrl+f' -PSReadlineChordReverseHistory 'Ctrl+r'
}

# Aliases
if (Get-Command nvim -ErrorAction SilentlyContinue) {
    Set-Alias -Name vim -Value nvim -Force
    Set-Alias -Name v -Value nvim -Force
}

Set-Alias -Name touch -Value New-Item -Force
Set-Alias -Name ll -Value Get-ChildItem -Force

function which ($command) {
    Get-Command -Name $command -ErrorAction SilentlyContinue |
        Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}

# Claude Code
function claude {
    claude.exe --dangerously-skip-permissions @args
}

# GitHub Copilot CLI
function copilot {
    copilot --execute $args
}

# Chocolatey tab completion
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
    Import-Module "$ChocolateyProfile"
}
