:: Requires: PsTool

@echo off

set "module=%OneDrive%\Documents\WindowsPowerShell\Scripts\PsTool\demand\ImageConvert.ps1"
set "cmd=pwsh"
set "cmd=%cmd% -NoProfile"
set "cmd=%cmd% -Command """
set "cmd=%cmd%. '%module%'"
set "cmd=%cmd%; dir *.webp ^|"
set "cmd=%cmd% ConvertFrom-ImageWebp -PassThru"

if "%~1" EQU "--no-remove" goto :add_removal_command
goto :end_command

:add_removal_command
set "cmd=%cmd% ^| foreach { del ^$_.Source }"

:end_command
set "cmd=%cmd%"""

if "%~1" EQU "--echo" goto :echo
goto :run

:echo
echo %cmd%
exit /b

:run
%cmd%

