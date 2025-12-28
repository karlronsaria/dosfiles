@echo off

if "%~2" EQU "--vscode" goto :vscode

set "wtsettingsloc=%LocalAppData%/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState"
set "wtbackuploc=%~dp0./backup/winterminal"

if "%~1" EQU "--help" goto :help
if "%~1" EQU "-h" goto :help
if "%~1" EQU "todd" goto :toddmode
if "%~1" EQU "vinny" goto :vinnymode
if "%~1" EQU "barry" goto :barrymode
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
set "walls=dir '%UserProfile%/Downloads/__OTHER/toddhoward/pic/wallready'"
set "pointer=ToddMode"
set "arrows= -FilePath (dir 'C:/shortcut/dos/res/toddhoward/emote/*.ico' _bar_ Get-Random)"
set "recyclebin=Not Skyrim"
set "wtsettings=toddhowardfestive.json"
set "toddmodeactive=1"
goto :setcmd

:vinnymode
set "walls=dir '%UserProfile%/Downloads/__OTHER/vinny/pic/wallready'"
set "pointer=VinnyMode"
set "arrows= -FilePath (dir 'C:/shortcut/dos/res/vinesauce/ico/*.ico' _bar_ Get-Random)"
set "recyclebin=Action 52"
set "wtsettings=vinnyvinesauce.json"
goto :setcmd

:barrymode
set "walls=dir '%UserProfile%/Downloads/__OTHER/barry-kramer/pic/wallready'"
set "pointer=BarryMode"
set "arrows= -FilePath (dir 'C:/shortcut/dos/res/barry/ico/*.ico' _bar_ Get-Random)"
set "recyclebin=Recycle Bin"
set "wtsettings=barrykramer.json"
goto :setcmd

:setcmd
set "wallCmd=$null = %walls%"
set "wallCmd=%wallCmd% _bar_ Get-Random"
set "wallCmd=%wallCmd% _bar_ foreach { if ($_.PsIsContainer) { dir $_ _bar_ Get-Random } else { $_ } }"
set "wallCmd=%wallCmd% _bar_ foreach { $_.FullName }"
set "wallCmd=%wallCmd% _bar_ Set-Wallpaper"

set "cmd=sudo pwsh"
:: :: (karlr 2024-12-24)
set "cmd=%cmd% -NoProfile"
set "cmd=%cmd% -Command ""
:: :: (karlr 2024-12-24)
:: set "cmd=%cmd%Import-DemandModule PsFrivolous, theme -Mode And"
set "cmd=%cmd%. \shortcut\pwsh\Scripts\PsFrivolous\demand\Theme.ps1"

if "%~2" EQU "--wallonly" goto :wallonly
if "%~3" EQU "--wallonly" goto :wallonly
goto :mainCmd

:wallonly
set "cmd=%cmd%; %wallCmd%"
goto :endSetCmd

:mainCmd
set "cmd=%cmd%; $null = Set-MousePointerTheme -Name %pointer%"
set "cmd=%cmd%; $null = Rename-DesktopItem -Special RecycleBin -NewName '%recyclebin%'"
set "cmd=%cmd%; $null = Set-ShortcutIconOverlay%arrows% -RestartExplorer -Force"
set "cmd=%cmd%; %wallCmd%"
set "cmd=%cmd%; $null = Copy-Item '%wtsettingsloc%/settings.json' -Dest "%wtbackuploc%/__OLD/wtsettings_-_$(Get-Date -f yyyy-MM-dd-HHmmss).json" -Force" :: Uses DateTimeFormat
set "cmd=%cmd%; $null = Copy-Item "%wtbackuploc%/%wtsettings%" -Dest '%wtsettingsloc%/settings.json' -Force"
set "cmd=%cmd%""
:endSetCmd

if "%~2" EQU "--whatif" goto :echo
if "%~3" EQU "--whatif" goto :echo
goto :execute

:echo
echo %cmd:_bar_=|%
exit /b

:execute
%cmd:_bar_=|%
if "%toddmodeactive%" EQU "1" goto :playSound
exit /b

:notImplemented
echo.This theme has not been implemeneted
exit /b

:help
echo.
echo.Usage: %~n0 [theme [--wallonly|--vscode] [--whatif]]
echo.
echo.Description:
echo.  Changes the system appearance based on a given theme
echo.
echo.Options:
echo.  --wallonly  Changes the wallpaper ^(desktop background^) only
echo.  --vscode    Switches to VS Code Mode: Swaps out the User Settings file ^(settings.json^)
echo.  --whatif    Echoes the full command
echo.  --help      Shows this help message
echo.    -h
echo.
echo.Examples:
echo.  %~n0
echo.  %~n0 todd
echo.  %~n0 vinny
echo.  %~n0 todd --whatif
echo.  %~n0 vinny --whatif
exit /b

:vscode
set "settingsloc=%AppData%/Code/User"
set "backuploc=%~dp0./backup/vscode"

if "%~1" EQU "--help" goto :help
if "%~1" EQU "-h" goto :help
if "%~1" EQU "todd" goto :vstoddmode
if "%~1" EQU "system" goto :vssystemdefault
if "%~1" EQU "" goto :vssystemdefault
goto :notImplemented

:vssystemdefault
set "settings=settings-nobg.json"
goto :vssetcmd

:vstoddmode
set "settings=settings-main.json"
goto :vssetcmd

:vssetcmd
set "cmd=sudo pwsh"
:: :: (karlr 2024-12-24)
set "cmd=%cmd% -NoProfile"
set "cmd=%cmd% -Command ""
set "cmd=%cmd%; $null = Copy-Item '%settingsloc%/settings.json' -Dest "%backuploc%/__OLD/settings_-_$(Get-Date -f yyyy-MM-dd-HHmmss).json" -Force" :: Uses DateTimeFormat
set "cmd=%cmd%; $null = Copy-Item "%backuploc%/%settings%" -Dest '%settingsloc%/settings.json' -Force"
set "cmd=%cmd%""
:vsendSetCmd

if "%~2" EQU "--whatif" goto :vsecho
if "%~3" EQU "--whatif" goto :vsecho
goto :vsexecute

:vsecho
echo %cmd:_bar_=|%
exit /b

:vsexecute
%cmd:_bar_=|%
exit /b

:playSound
set "sound=%~dp0./res/toddhoward/sfx/toddhoward_-_welcome-aboard-captain-[k9r0VhwBbt0].wav"
pwsh -NoProfile -Command ^
  "(New-Object System.Media.SoundPlayer '%sound%').PlaySync()"

exit /b
