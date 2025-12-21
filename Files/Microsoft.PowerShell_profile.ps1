# Oh My Posh initialization - using environment variable for theme path
$ohMyPoshTheme = if ($env:OH_MY_POSH_THEME) { $env:OH_MY_POSH_THEME } else { "$PSScriptRoot\clean-detailed.omp.json" }
oh-my-posh init pwsh --config $ohMyPoshTheme | Invoke-Expression

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

# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
