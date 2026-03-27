@echo off

:: (karlr 2025-12-11): Adding a remote to most or all repositories,
:: anticipating a migration from GitHub to Codeberg.
::
:: - link
::   - url
::      - <https://codeberg.org>
::      - <https://www.youtube.com/watch?v=E3_95BZYIVs>
::    - retrieved: 2025-12-10

if "%~1" EQU "" goto :default
if "%~1" EQU "--whatif" goto :default
set "repo=%~1"
goto :setCmd

:default
:: Treat the working directory's folder name as the name of the repository
for %%A in ("%CD%") do set "repo=%%~nA"

:setCmd
set "username=karlronsaria"
set "cmd1=git remote set-url --add --push origin https://github.com/%username%/%repo%.git"
set "cmd2=git remote set-url --add --push origin git@codeberg.org:%username%/%repo%.git"

:: :: (karlr 2026-01-09): switch to SSH transport (scp-style SSH URL)
:: :: - [x] issue 2026-01-09-023600
:: ::   - where: git
:: ::   - description: git repo with a Codeberg remote fails to push, needs to
:: ::     re-authenticate often by opening a browser to the site
:: ::   - solution
:: ::     - switch to SSH transport syntax to take advantage of saved SSH keys
:: set "cmd2=git remote set-url --add --push origin https://codeberg.org/%username%/%repo%.git"

if "%~1" EQU "--whatif" goto :echo
if "%~2" EQU "--whatif" goto :echo
goto :execute

:execute
%cmd1%
%cmd2%
exit /b

:echo
echo.%cmd1%
echo.%cmd2%
exit /b

:help
echo.
echo.Usage: %~n0 [repo [--whatif]]
echo.
echo.Description:
echo.  Adds all relevant remotes to a given local Git repository
echo.
echo.Options:
echo.  --whatif    Echoes the full command
echo.  --help      Shows this help message
echo.    -h
echo.
echo.Examples:
echo.  %~n0
echo.  %~n0 PsTool
echo.  %~n0 PsTool --whatif
exit /b

