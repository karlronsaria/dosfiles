@echo off

set "timeout=7"
set "folder=capture"
set "caption=Saving image to log"

set "ps=. '%~dp0./pwsh/ClipGraphic.ps1'"
set "ps=%ps%;. '%~dp0./pwsh/Toast.ps1'"
set "ps=%ps%; $what = Save-ClipboardAsGraphic -BasePath '%~dp0./log' -FolderName '%folder%'"
set "ps=%ps%; $(if ($what.Success) { $what.Path } else { 'Image not found on clipboard' })"
set "ps=%ps% _bar_ Out-Toast -Title '%caption%' -SuggestedTimeout %timeout%"

set "command=pwsh -NoProfile -Command "%ps%""

if "%~1" EQU "--whatif" goto :whatif
if "%~1" EQU "--tops" goto :tops
goto :execute

:tops
echo %ps:_bar_=^|%
exit /b

:whatif
set "command=%command:$=`$%"
echo %command:_bar_=|%
exit /b

:execute
%command:_bar_=|%

