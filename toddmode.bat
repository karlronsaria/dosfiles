@echo off

if "%~1" EQU "--help" goto :help
if "%~1" EQU "-h" goto :help

set "cmd=sudo pwsh"
set "sysWalls=dir '%windir%/Web/*.jpg' -Recurse"
set "myWalls=dir '%UserProfile%/Downloads/__OTHER/toddhoward/pic/wallready'"
set "myArrow='C:/shortcut/dos/res/toddhoward/emote/todd-emote-color-wide.ico'"

:: :: (karlr 2024_12_24)
set "cmd=%cmd% -NoProfile "
set "cmd=%cmd% -Command ""
:: :: (karlr 2024_12_24)
:: set "cmd=%cmd%Import-DemandModule PsFrivolous, theme -Mode And"
set "cmd=%cmd%. %OneDrive%\Documents\WindowsPowerShell\Scripts\PsFrivolous\demand\Theme.ps1"
set "cmd=%cmd%; $null = Set-MousePointerTheme"

if "%~1" EQU "" goto :setToddMode
if "%~1" EQU "--on" goto :setToddMode
if "%~1" EQU "--off" goto :setDefaultMode
goto :notImplemented

:setToddMode
set "walls=%myWalls%"
set "cmd=%cmd%; $null = Set-MousePointerTheme -Name ToddMode"
set "cmd=%cmd%; $null = Rename-DesktopItem -Special RecycleBin -NewName 'Not Skyrim'"
set "cmd=%cmd%; $null = Set-ShortcutIconOverlay -FilePath %myArrow%"
goto :completeCmd

:setDefaultMode
set "walls=%sysWalls%"
set "cmd=%cmd%; $null = Set-MousePointerTheme -Name SystemDefault"
set "cmd=%cmd%; $null = Rename-DesktopItem -Special RecycleBin -NewName 'Recycle Bin'"
set "cmd=%cmd%; $null = Set-ShortcutIconOverlay"
goto :completeCmd

:completeCmd
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
echo.Usage: %~n0 [--on^|--off [--whatif]]
echo.
echo.Options:
echo.  --on       Activates Todd Mode
echo.  --off      Deactivates Todd Mode, sets to default theme
echo.  --whatif   Echoes the full command
echo.
echo.Examples:
echo.  %~n0
echo.  %~n0 --on
echo.  %~n0 --off
echo.  %~n0 --on --whatif
echo.  %~n0 --off --whatif
exit /b

