@echo off

if "%~1" EQU "--help" goto :help
if "%~1" EQU "-h" goto :help

set "cmd=pwsh -Command ""
set "cmd=%cmd%Import-DemandModule theme, mouse, pointer -Mode And"
set "cmd=%cmd%; Set-MousePointerTheme"

if "%~1" EQU "" goto :setToddMode
if "%~1" EQU "--on" goto :setToddMode
if "%~1" EQU "--off" goto :setDefaultMode
goto :notImplemented

:setToddMode
set "cmd=%cmd% -Name ToddMode"
goto :completeCmd

:setDefaultMode
set "cmd=%cmd% -Name SystemDefault"
goto :completeCmd

:completeCmd
set "cmd=%cmd%""

if "%~2" EQU "--whatif" goto :echo
goto :execute

:echo
echo %cmd%
exit /b

:execute
%cmd%
exit /b

:notImplemented
echo.This theme has not been implemeneted
exit /b

:help
echo.
echo.Usage: %~n0 [--on^|--off [--whatif]]
echo.
echo.Options:
echo.  --on       Activates Todd Mode
echo.  --off      Deactivates Todd Mode, sets to default theme
echo.  --whatif   Echoes the full command
echo.
echo.Examples:
echo.  %~n0
echo.  %~n0 --on
echo.  %~n0 --off
echo.  %~n0 --on --whatif
echo.  %~n0 --off --whatif
exit /b

