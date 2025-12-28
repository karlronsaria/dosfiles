@echo off
set "defaultWorld=2025-02-03-uan"
set "minecraftDir=%AppData%\.minecraft\saves"
set "destinationDir=%OneDrive%\Documents\backup\minecraft"

if "%~1" EQU "" goto :default
set "world=%~1"
goto :backup

:default
set "world=%defaultWorld%"
goto :backup

:backup
set "command=7z a -r -t7z "%destinationDir%\%world%-$(Get-Date -f yyyy-MM-dd-HHmmss)" %minecraftDir%\%world%\*.*"

if "%~1" EQU "--tops" goto :tops
if "%~2" EQU "--tops" goto :tops
goto :exec

:tops
echo %command%
exit /b

:exec
pwsh -NoProfile -Command "%command%"

:: "C:\Program Files (x86)\Minecraft Launcher\MinecraftLauncher.exe"

