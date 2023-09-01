@echo off
set "cmd=chrome.exe %*"
set "modulePath=%~dp0\ps\ShortcutGoogleChrome"

if "%~1" EQU "-p" goto getNewCommand
goto runCommand

:getNewCommand
set "cmd=powershell -Command """
set "cmd=%cmd%; %modulePath%\Get-Scripts.ps1 ^| foreach { . $_ } "
set "cmd=%cmd%; Run-ShortcutGoogleChromeProfile %2 %3 %4 %5 %6"
set "cmd=%cmd%"""

:runCommand
%cmd%
