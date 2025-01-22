@echo off

if "%~1" EQU "--help" goto :help
if "%~1" EQU "-h" goto :help

set "cmd=sudo pwsh"

if "%~1" EQU "" goto :systemdefault
if "%~1" EQU "system" goto :systemdefault
if "%~1" EQU "todd" goto :toddmode
if "%~1" EQU "vinny" goto :vinnymode
goto :notImplemented

:systemdefault
set "walls=dir '%windir%/Web/*.jpg' -Recurse"
set "pointer=SystemDefault"
set "arrow="
set "recyclebin=Recycle Bin"

:toddmode
set "walls=dir '%UserProfile%/Downloads/__OTHER/toddhoward/pic/wallready'"
set "pointer=ToddMode"
set "arrow= -FilePath 'C:/shortcut/dos/res/toddhoward/emote/todd-emote-color-wide.ico'"
set "recyclebin=Not Skyrim"

:vinnymode
set "walls=dir '%UserProfile%/Downloads/__OTHER/vinny/pic/wallready'"
set "pointer=VinnyMode"
set "arrow= -FilePath 'C:/shortcut/dos/res/vinesauce/ico/vinny-point-extend.ico'"
set "recyclebin=Action 52"

:: :: (karlr 2024_12_24)
set "cmd=%cmd% -NoProfile "
set "cmd=%cmd% -Command ""
:: :: (karlr 2024_12_24)
:: set "cmd=%cmd%Import-DemandModule PsFrivolous, theme -Mode And"
set "cmd=%cmd%. %OneDrive%\Documents\WindowsPowerShell\Scripts\PsFrivolous\demand\Theme.ps1"
set "cmd=%cmd%; $null = Set-MousePointerTheme"
set "cmd=%cmd%; $null = Set-MousePointerTheme -Name %pointer%"
set "cmd=%cmd%; $null = Rename-DesktopItem -Special RecycleBin -NewName '%recyclebin%'"
set "cmd=%cmd%; $null = Set-ShortcutIconOverlay%arrow%"
set "cmd=%cmd% -RestartExplorer"
set "cmd=%cmd%; $null = %walls% ^^^| Get-Random ^^^| foreach { $_.FullName } ^^^| Set-Wallpaper"
set "cmd=%cmd% -Style Fill""

if "%~2" EQU "--whatif" goto :echo
goto :execute

:echo
echo %cmd%
exit /b

:execute
%cmd%
exit /b

:notImplemented
echo.This theme has not been implemeneted
exit /b

:help
echo.
echo.Usage: %~n0 [theme [--whatif]]
echo.
echo.Description:
echo.  Changes the system theme based on saved theme profiles.
echo.
echo.Options:
echo.  --whatif   Echoes the full command
echo.  --help     Shows this help message
echo.
echo.Examples:
echo.  %~n0
echo.  %~n0 todd
echo.  %~n0 vinny
echo.  %~n0 todd --whatif
echo.  %~n0 vinny --whatif
exit /b

