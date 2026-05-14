@echo off

setlocal EnableDelayedExpansion

for /f %%d in ('where.exe %~n0.exe') do (
    set "what=%%d"
)

if "!what!"=="" (
    set "what=nvim"
)

title !what!
endlocal

set "resdir=%~dp0..\res"
:: set "command1=powershell -Command %resdir%\Set-ConsoleIcon.ps1 -IconFile %resdir%\nvim.ico"
set "command2=%~n0.exe %*"
:: set "command=cmd /c %command1% ^& %command2% ^& exit"
set "command=cmd /c %command2%"

%command%

