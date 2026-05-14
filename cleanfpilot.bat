@echo off

:: Uses DateTimeFormat
move "%APPDATA%\Voidstar\FilePilot\FPilot-UserData.json" "C:\$Recycle.Bin\FPilot-UserData-%date:~10,4%-%date:~4,2%-%date:~7,2%-%time:~0,2%%time:~3,2%%time:~6,2%.json"

