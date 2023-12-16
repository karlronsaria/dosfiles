:: Requires: PsTool

@echo off

set "module=%OneDrive%\Documents\WindowsPowerShell\Scripts\PsTool\demand\ImageConvert.ps1"
set "path=%~dp0."
set "cmd=pwsh"
set "cmd=%cmd% -NoProfile"
set "cmd=%cmd% -Command '"
set "cmd=%cmd%. '%module%'"
set "cmd=%cmd%; dir "%path%\*.webp" ^| ConvertFrom-ImageWebp -PassThru"
set "cmd=%cmd%; del "%path%\*.webp""
set "cmd=%cmd%'"

if "%1" EQU "-echo" goto :echo
goto :run

:echo
echo %cmd%
exit /b

:run
%cmd%

