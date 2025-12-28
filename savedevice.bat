@echo off

set "command=pwsh -Command ""
set "command=%command%demand MtpDevice"
set "command=%command%; Get-MtpDeviceItem -Query"
set "command=%command% '{ ""Internal storage"": [""Download"", ""Pictures"", ""DCIM""] }'"
set "command=%command% _bar_ foreach { $_.'Internal storage' }"
set "command=%command% _bar_ foreach { $_.SaveTo('%SystemDrive%/temp/mobile') }"
set "command=%command%""

if "%~1" EQU "--whatif" goto :echo
goto :execute

:echo
echo %command:_bar_=|%
exit /b

:execute
%command:_bar_=|%
exit /b

