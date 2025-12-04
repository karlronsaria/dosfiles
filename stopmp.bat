sudo pwsh -noprofile -command 'add-MpPreference -ExclusionProcess "cmd.exe", "nvim.exe", "pwsh.exe", "powershell.exe"; dir C:\shortcut\pwsh\*.ps1 -Recurse ^| foreach { Set-MpPreference -ExclusionPath $_.FullName -Force }'

