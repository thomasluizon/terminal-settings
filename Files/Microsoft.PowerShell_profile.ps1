$theme = if ($env:OH_MY_POSH_THEME) { $env:OH_MY_POSH_THEME }
         elseif (Test-Path "$PSScriptRoot\clean-detailed.omp.json") { "$PSScriptRoot\clean-detailed.omp.json" }
         else { "$env:POSH_THEMES_PATH\clean-detailed.omp.json" }
if (Test-Path $theme) {
    $ompCache = "$env:LOCALAPPDATA\omp-init.pwsh.ps1"
    $ompExe = (Get-Command oh-my-posh -ErrorAction SilentlyContinue).Source
    $ompFresh = (Test-Path $ompCache) -and
                ((Get-Item $ompCache).LastWriteTimeUtc -ge (Get-Item $theme).LastWriteTimeUtc) -and
                (-not $ompExe -or (Get-Item $ompCache).LastWriteTimeUtc -ge (Get-Item $ompExe).LastWriteTimeUtc)
    if (-not $ompFresh) {
        (oh-my-posh init pwsh --config $theme) -replace '\$env:POSH_SESSION_ID\s*=\s*"[^"]*";', '' |
            Set-Content -Encoding utf8 $ompCache
    }
    $env:POSH_SESSION_ID = [guid]::NewGuid().ToString()
    try { . $ompCache }
    catch {
        (oh-my-posh init pwsh --config $theme) -replace '\$env:POSH_SESSION_ID\s*=\s*"[^"]*";', '' |
            Set-Content -Encoding utf8 $ompCache
        . $ompCache
    }
}

Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineOption -HistorySearchCursorMovesToEnd -ShowToolTips
if (-not [Console]::IsOutputRedirected -and -not [Console]::IsInputRedirected) {
    try { Set-PSReadLineOption -PredictionSource History } catch {}
}
Set-PSReadLineKeyHandler -Chord 'Ctrl+v' -Function Paste
Set-PSReadLineKeyHandler -Chord 'Ctrl+c' -Function CopyOrCancelLine
Set-PSReadLineKeyHandler -Chord 'Ctrl+x' -Function Cut
Set-PSReadLineKeyHandler -Chord 'Ctrl+a' -Function SelectAll

function global:__ensure-terminal-icons {
    if (-not (Get-Module Terminal-Icons)) { Import-Module Terminal-Icons -ErrorAction SilentlyContinue }
}
function global:ls  { __ensure-terminal-icons; Get-ChildItem @args }
function global:ll  { __ensure-terminal-icons; Get-ChildItem @args }
function global:dir { __ensure-terminal-icons; Get-ChildItem @args }

Set-PSReadLineKeyHandler -Chord 'Ctrl+r' -ScriptBlock {
    Import-Module PSFzf -ErrorAction SilentlyContinue
    Set-PSFzfOption -PSReadlineChordProvider 'Ctrl+f' -PSReadlineChordReverseHistory 'Ctrl+r'
    Invoke-FzfPsReadlineHandlerHistory
}
Set-PSReadLineKeyHandler -Chord 'Ctrl+f' -ScriptBlock {
    Import-Module PSFzf -ErrorAction SilentlyContinue
    Set-PSFzfOption -PSReadlineChordProvider 'Ctrl+f' -PSReadlineChordReverseHistory 'Ctrl+r'
    Invoke-FzfPsReadlineHandlerProvider
}

if (Get-Command nvim -ErrorAction SilentlyContinue) {
    Set-Alias -Name vim -Value nvim -Force
    Set-Alias -Name v -Value nvim -Force
}
Set-Alias -Name touch -Value New-Item -Force
function which ($command) {
    (Get-Command -Name $command -ErrorAction SilentlyContinue).Path
}
function claude  { claude.exe --dangerously-skip-permissions @args }
function copilot { copilot --execute $args }

$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path $ChocolateyProfile) { Import-Module "$ChocolateyProfile" }
