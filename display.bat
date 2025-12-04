@echo off

if "%~1" EQU "--help" goto :help
if "%~1" EQU "-h" goto :help
if "%~1" EQU "/?" goto :help
goto :run

:help
echo.DISPLAYSWITCH.exe
echo.Specify which display to use and how to use it.
echo.
echo.Syntax
echo.      DISPLAYSWITCH /Option
echo.
echo.Options
echo.       /internal    Switch to use the primary display only.
echo.       1            All other connected displays will be disabled.
echo.
echo.       /clone       The primary display will be mirrored on a second screen.
echo.       2
echo.
echo.       /extend      Expand the Desktop to a secondary display.
echo.       3            This allows one desktop to span multiple displays. (Default).
echo.
echo.       /external    Switch to the external display only (second screen).
echo.       4            The current main display will be disabled.
echo.
echo.Running DisplaySwitch.exe without any options will open a GUI.
echo.The command is located at: "%SystemRoot%\System32\DisplaySwitch.exe"
echo.
echo.Examples
echo.Mirror the current Desktop on a secondary display:
echo.
echo.C:\^> DisplaySwitch /clone
echo.
echo.Extend the Desktop to a secondary display:
echo.
echo.C:\^> DisplaySwitch 3
echo.
echo.link: ss64.com
echo.- url: ^<https://ss64.com/nt/displayswitch.html^>
echo.- retrieved: 2025-07-24
exit /b

:run
displayswitch.exe %*

