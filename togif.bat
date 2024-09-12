@echo off
set "modulePath=%~dp0\pwsh\ShortcutFfmpeg"

if "%~1" EQU "" goto :eof

set "cmd=powershell -Command """
set "cmd=%cmd%; %modulePath%\Get-Scripts.ps1 ^| foreach { . $_ } "
set "cmd=%cmd%; """%*""" ^| Convert-Ffmpeg -To gif"
set "cmd=%cmd%"""

%cmd%
