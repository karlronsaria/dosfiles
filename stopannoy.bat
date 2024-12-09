@echo off

set "app=pwsh"
set "command="
set "command=%command%'4kvideodownloaderplus'"
set "command=%command%, 'steam'"
set "command=%command%, 'steamservice'"
set "command=%command%, 'steamhelper'"
set "command=%command% ^| foreach { Get-Process ^$_ -ErrorAction Continue }"
set "command=%command% ^| foreach { Stop-Process ^$_ -Force }"
set "command=%app% -NoProfile -Command "%command%""

IF "%~1" EQU "--whatif" goto :whatif
goto :command

:whatif
echo %command%
exit /B

:command
%command%

