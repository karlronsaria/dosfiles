@echo off
set "command=%LOCALAPPDATA%\nvim\pwsh\Get-DateStringFromCalendar.ps1"

if "%~1" EQU "--where" goto :where
if "%~1" EQU "--tops" goto :tops
goto :exec

:where
echo %command%
exit /b

:tops
type %command%
exit /b

:exec
pwsh -NoProfile -Command "%command%"

