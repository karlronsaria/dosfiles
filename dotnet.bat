@echo off
set "appname=dotnet.exe"
set "args="
set "simplebuildstring=publish -r win-x64 -c Release /p:PublishSingleFile=true"
setlocal EnableDelayedEXpansion

if "%~1"=="simplebuild" (
    set "args= %simplebuildstring%"
    if "%~2"=="--help" goto Help
    shift
)

:Loop
if "%~1"=="" goto Continue
set "args=!args! %1"
shift
goto Loop

:Continue
%appname%!args!
endlocal
exit /b

:Help
echo.Equivalent:
echo.  dotnet %simplebuildstring%
exit /b

