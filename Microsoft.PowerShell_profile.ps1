oh-my-posh init pwsh --config 'C:\Users\thoma\AppData\Local\Programs\oh-my-posh\themes\catppuccin.omp.json' | Invoke-Expression

Import-Module Terminal-Icons
Import-Module PSFzf

#Imports PSReadLine
Import-Module PSReadLine

#Tab - Gives a menu of suggestions
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete

#UpArrow will show the most recent command
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward

#DownArrow will show the least recent command
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward

#During auto completion, pressing arrow key up or down will move the cursor to the end of the completion
Set-PSReadLineOption -HistorySearchCursorMovesToEnd

#Shows tooltip during completion
Set-PSReadLineOption -ShowToolTips

#Gives completions/suggestions from historical commands
Set-PSReadLineOption -PredictionSource History

Set-PSFzfOption -PSReadlineChordProvider 'Ctrl+f' -PSReadlineChordReverseHistory 'Ctrl+r'

Set-Alias vim nvim

function which ($command) {
	Get-Command -Name $command -ErrorAction SilentlyContinue |
		Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}