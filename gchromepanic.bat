@echo off
set "modulePath=%~dp0\pwsh\ShortcutGoogleChrome"

set "cmd=powershell -NoProfile -Command """
set "cmd=%cmd%; %modulePath%\Get-Scripts.ps1 ^| foreach { . $_ } "
set "cmd=%cmd%; Stop-ShortcutGoogleChrome"
set "cmd=%cmd%"""

%cmd%
