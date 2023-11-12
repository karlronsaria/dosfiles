@echo off

set "app=pwsh"

if "%~1" EQU "" goto :setCmd
if "%~1" EQU "--whatif" goto :setCmd

set "app=%~1"

:setCmd
set "cmd=$proc = Start-Process %app% -PassThru -NoNewWindow -ArgumentList"
set "cmd=%cmd% '-NoExit', '-Command',"
set "cmd=%cmd% '. %OneDrive%/Documents/WindowsPowerShell/hellfile.ps1';"
set "cmd=%cmd% $player = New-Object System.Media.SoundPlayer;"
set "cmd=%cmd% $player.SoundLocation ="
set "cmd=%cmd% '%~dp0./res/off-i-go-then_-_175speed.wav';"
set "cmd=%cmd% $proc.WaitForExit();"
set "cmd=%cmd% $player.PlaySync();"
set "cmd=%cmd% exit"

set "cmd=%app% -NoExit -Command "%cmd%""

if "%~1" EQU "--whatif" goto :whatif
goto :run

:whatif
echo %cmd%
exit /b

:run
%cmd%
