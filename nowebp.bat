:: Requires: PsTool

@echo off

:: :: (karlr 2025-07-10)
:: set "module=%OneDrive%\Documents\WindowsPowerShell\Scripts\PsTool\demand\ImageConvert.ps1"
set "module=C:\shortcut\pwsh\Scripts\PsTool\demand\ImageConvert.ps1"
set "cmd=pwsh"
set "cmd=%cmd% -NoProfile"
set "cmd=%cmd% -Command """
set "cmd=%cmd%. '%module%'"
set "cmd=%cmd%; dir *.webp ^|"
set "cmd=%cmd% ConvertFrom-ImageWebp -PassThru"

if "%~1" EQU "--no-remove" goto :end_command
goto :add_removal_command

:add_removal_command
:: :: - [x] issue 2025-10-09-161246
:: ::   - actual: files keep getting deleted by mistake
:: set "cmd=%cmd% ^| foreach { del ^$_.Source }"
set "cmd=%cmd% ^| foreach {"
set "cmd=%cmd% ^$app = (New-Object -ComObject 'Shell.Application')"
set "cmd=%cmd%; ^$itemName = (Get-Item ^$_.Source).FullName"
set "cmd=%cmd%; ^$item = ^$app.Namespace(0).ParseName(^$itemName)"
set "cmd=%cmd%; ^$item.InvokeVerb('delete')"
set "cmd=%cmd% }"

:end_command
set "cmd=%cmd%"""

if "%~1" EQU "--whatif" goto :echo
goto :run

:echo
echo %cmd%
exit /b

:run
%cmd%

