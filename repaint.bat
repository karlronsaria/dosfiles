@echo off

set "wtsettingsloc=%LocalAppData%/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState"
set "wtbackuploc=%~dp0./backup/winterminal"

if "%~1" EQU "--help" goto :help
if "%~1" EQU "-h" goto :help
if "%~1" EQU "todd" goto :toddmode
if "%~1" EQU "vinny" goto :vinnymode
if "%~1" EQU "system" goto :systemdefault
if "%~1" EQU "" goto :systemdefault
goto :notImplemented

:systemdefault
set "walls=dir '%windir%/Web/*.jpg' -Recurse"
set "pointer=SystemDefault"
set "arrows="
set "recyclebin=Recycle Bin"
set "wtsettings=no-image.json"
goto :setcmd

:toddmode
set "walls=dir '%UserProfile%/Downloads/__OTHER/toddhoward/pic/wallready/*.*'"
set "pointer=ToddMode"
set "arrows= -FilePath (dir 'C:/shortcut/dos/res/toddhoward/emote/*.ico' _bar_ Get-Random)"
set "recyclebin=Not Skyrim"
set "wtsettings=toddhoward.json"
goto :setcmd

:vinnymode
set "walls=dir '%UserProfile%/Downloads/__OTHER/vinny/pic/wallready/*.*'"
set "pointer=VinnyMode"
set "arrows= -FilePath (dir 'C:/shortcut/dos/res/vinesauce/ico/*.ico' _bar_ Get-Random)"
set "recyclebin=Action 52"
set "wtsettings=toddhoward.json"
goto :setcmd

:setcmd
set "cmd=sudo pwsh"
:: :: (karlr 2024_12_24)
set "cmd=%cmd% -NoProfile"
set "cmd=%cmd% -Command ""
:: :: (karlr 2024_12_24)
:: set "cmd=%cmd%Import-DemandModule PsFrivolous, theme -Mode And"
set "cmd=%cmd%. %OneDrive%\Documents\WindowsPowerShell\Scripts\PsFrivolous\demand\Theme.ps1"
set "cmd=%cmd%; $null = Set-MousePointerTheme -Name %pointer%"
set "cmd=%cmd%; $null = Rename-DesktopItem -Special RecycleBin -NewName '%recyclebin%'"
set "cmd=%cmd%; $null = Set-ShortcutIconOverlay%arrows% -RestartExplorer -Force"
set "cmd=%cmd%; $null = %walls% _bar_ Get-Random _bar_ foreach { $_.FullName } _bar_ Set-Wallpaper"
set "cmd=%cmd%; $null = Copy-Item '%wtsettingsloc%/settings.json' -Dest "%wtbackuploc%/__OLD/wtsettings_-_$(Get-Date -f yyyy_MM_dd_HHmmss).json" -Force"
set "cmd=%cmd%; $null = Copy-Item "%wtbackuploc%/%wtsettings%" -Dest '%wtsettingsloc%/settings.json' -Force"
set "cmd=%cmd%""

if "%~2" EQU "--whatif" goto :echo
goto :execute

:echo
echo %cmd:_bar_=|%
exit /b

:execute
%cmd:_bar_=|%
exit /b

:notImplemented
echo.This theme has not been implemeneted
exit /b

:help
echo.
echo.Usage: %~n0 [theme [--whatif]]
echo.
echo.Description:
echo.  Changes the system appearance based on a given theme
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

