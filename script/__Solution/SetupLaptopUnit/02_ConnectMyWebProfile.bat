@echo off
set "script=Connect-CNWebProfile"
set "comm=powershell -Command "". %~dp0./script/RunMyScript.ps1"
set "comm=%comm% -Name """%~n0""""
set "comm=%comm% -Message """Connecting to WiFi...""""
set "comm=%comm% -ScriptBlock { %script% }"
set "comm=%comm%"""
%comm%
