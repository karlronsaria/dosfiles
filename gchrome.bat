@echo off
set "cmd=chrome.exe %*"
set "modulePath=%~dp0\pwsh\ShortcutGoogleChrome"

if "%~1" EQU "-p" goto getNewCommand
goto runCommand

:getNewCommand
set "cmd=pwsh -NoProfile -Command """
set "cmd=%cmd%; %modulePath%\Get-Scripts.ps1 ^| foreach { . $_ } "
set "cmd=%cmd%; Start-ShortcutGoogleChromeProfile %*"
set "cmd=%cmd%"""

:runCommand
%cmd%
