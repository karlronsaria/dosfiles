@echo off

:: Uses DateTimeFormat
set "mydate=%date:~10,4%-%date:~4,2%-%date:~7,2%"
set "mytime=%time:~0,2%%time:~3,2%%time:~6,2%%time:~9,2%0"

cp "%AppData%/Code/User/settings.json" "%~dp0./settings-%mydate%-%mytime%.json"
cp "%AppData%/Code/User/keybindings.json" "%~dp0./keybindings-%mydate%-%mytime%.json"

if EXIST %fullname% goto :fileSaved

echo.Something went wrong. File not saved.
echo.
exit /b

:fileSaved
echo.File saved.
echo.
echo.  %fullname%
echo.

