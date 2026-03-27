:: # LINK
:: - Url: <https://www.sumatrapdfreader.org/docs/Command-line-arguments>
:: - Retrieved: 2026-02-04

@echo off

if "%~1" EQU "--help" goto :help
if "%~1" EQU "-h" goto :help
goto :execute

:: (karlr 2026-02-10)
set "default=-reuse-instance"

:help
setlocal EnableDelayedExpansion
set "helpuri=https://www.sumatrapdfreader.org/docs/Command-line-arguments"

set "webRequest="
for /F %%a in ('curl %helpuri% 2^>^&1 ') do (
    set "webRequest=%%a"
)

if "!webRequest!" EQU "" goto :openLocal
goto :openOnline

:openLocal
set "helpuri=%~dp0./res/org.sumatrapdfreader.docs.command-line-arguments.html"

:openOnline
pwsh -NoProfile -Command "Start-Process '%helpuri%'"
endlocal
exit /B

:execute
start "" /B "%ProgramFiles%\SumatraPDF\SumatraPDF.exe" %* %default%
exit /B

