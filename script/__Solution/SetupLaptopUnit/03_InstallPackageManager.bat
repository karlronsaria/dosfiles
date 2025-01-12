@echo off
set "script=Install-Chocolatey"
set "comm=powershell -Command "". %~dp0./script/RunMyScript.ps1"
set "comm=%comm% -Name """%~n0""""
set "comm=%comm% -Message """Installing package manager, Chocolatey...""""
set "comm=%comm% -ScriptBlock { %script% }"
set "comm=%comm%"""
%comm%

