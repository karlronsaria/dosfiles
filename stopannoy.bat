@echo off

set "app=pwsh"
set "command="
set "command=%command%'4kvideodownloaderplus'"
set "command=%command%, 'steam'"
set "command=%command%, 'steamservice'"
set "command=%command%, 'steamhelper'"

:: (karlr 2025-09-02)
set "command=%command%, 'MinecraftEducationUpdater'"

:: (karlr 2025-09-04)
set "command=%command%, 'GOG Galaxy Notifications Renderer'"
set "command=%command%, 'GalaxyClient'"
set "command=%command%, 'GalaxyClient Helper'"
set "command=%command%, 'GalaxyCommunication'"

:: (karlr 2025-11-12)
set "command=%command%, 'Battle.net'"

:: (karlr 2025-11-19)
set "command=%command%, 'Unity Hub'"
set "command=%command%, 'Unity.Licensing.Client'"

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

