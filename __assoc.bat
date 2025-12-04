@echo off
set "file_loc=%~dp0.\assoc"

if "%~1" EQU "" goto :list
goto :set

:list
dir /b "%file_loc%\*.xml"
exit /b

:set
sudo dism /online /import-defaultappassociations:%file_loc%\%~1.xml

