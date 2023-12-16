:: Requires: PsTool

@echo off

set "module=%OneDrive%\Documents\WindowsPowerShell\Scripts\PsTool\demand\ImageConvert.ps1"
set "cmd=powershell"
set "cmd=%cmd% -NoProfile"
set "cmd=%cmd% -Command """
set "cmd=%cmd%. '%module%'"
set "cmd=%cmd%; dir *.webp ^| ConvertFrom-ImageWebp -PassThru"
set "cmd=%cmd%; del *.webp"
set "cmd=%cmd%"""

if "%1" EQU "-echo" goto :echo
goto :run

:echo
echo %cmd%
exit /b

:run
%cmd%

