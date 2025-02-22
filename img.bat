@echo off

set "folder=capture"
set "caption=Saving image to log"
set "command=pwsh -NoProfile -Command ""
set "command=%command%. '%~dp0./pwsh/ClipImage.ps1'"
set "command=%command%;. '%~dp0./pwsh/Toast.ps1'"
set "command=%command%; $what = Save-ClipboardToImageFormat -BasePath '%~dp0./log' -FolderName '%folder%'"
set "command=%command%; $(if ($what.Success) { $what.Path } else { 'Image not found on clipboard' }) _bar_ Out-Toast -Title '%caption%'"
set "command=%command%""

if "%~1" EQU "--whatif" goto :whatif
goto :execute

:whatif
echo %command:_bar_=|%
exit /b

:execute
%command:_bar_=|%

