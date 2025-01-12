@echo off
set "comm=powershell -Command "". %~dp0./script/MyScript.ps1;"
set "comm=%comm% Write-Output (Get-Setting -FileName 'session.json').LastAction;"
set "comm=%comm%"""
%comm%

