@echo off
set "script=Install-CNPackage"
set "comm=powershell -Command "". %~dp0./script/RunMyScript.ps1"
set "comm=%comm% -Name """%~n0""""
set "comm=%comm% -Message """Installing packages...""""
set "comm=%comm% -ScriptBlock { %script% }"
set "comm=%comm%"""
%comm%
