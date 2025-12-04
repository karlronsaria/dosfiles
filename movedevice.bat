@echo off

set "command=pwsh -Command ""
set "command=%command%demand ConnectedDevice"
set "command=%command%; Get-ConnectedDeviceItem -Query"
set "command=%command% '{ ""Internal storage"": [""Downloads"", ""Pictures"", ""DCIM""] }'"
set "command=%command% _bar_ foreach { $_.'Internal storage'.MoveTo('%SystemDrive%/temp/mobile') }"
set "command=%command%""

if "%~1" EQU "--whatif" goto :echo
goto :execute

:echo
echo %command:_bar_=|%
exit /b

:execute
%command:_bar_=|%
exit /b

