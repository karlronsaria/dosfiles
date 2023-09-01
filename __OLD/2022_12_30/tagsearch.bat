@echo off

set "dir=\note\sched"
set "defaultSubdir=general"
set "getScripts=%OneDrive%\Documents\devlib\powershell\PsSchedule\Get-Scripts.ps1"
set "params=%*"

set "cmd=%getScripts% | foreach { . $_ }"
set "cmd=%cmd%; Get-Schedule"
set "cmd=%cmd% -Directory "%dir%""
set "cmd=%cmd% -DefaultSubdirectory "%defaultSubdir%""
set "cmd=%cmd% -Recurse"
set "cmd=%cmd% %params%"
set "cmd=%cmd% | Write-Schedule"

powershell -Command "%cmd%"
