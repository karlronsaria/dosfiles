@echo off
set "script=Set-ExecutionPolicy RemoteSigned -Force; New-CNLocalUser; Save-CurrentLoginUser"
set "comm=powershell -Command "". %~dp0./script/RunMyScript.ps1"
set "comm=%comm% -Name """%~n0""""
set "comm=%comm% -Message """Creating new CN local users...""""
set "comm=%comm% -ScriptBlock { %script% }"
set "comm=%comm%"""
%comm%

