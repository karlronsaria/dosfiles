@echo off
set "script=Remove-LastLoginUser"
set "comm=powershell -Command "". %~dp0./script/RunMyScript.ps1"
set "comm=%comm% -Name """%~n0""""
set "comm=%comm% -Message """Removing previously logged-in user...""""
set "comm=%comm% -ScriptBlock { %script% }"
set "comm=%comm%"""
%comm%

