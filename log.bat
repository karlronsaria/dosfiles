@echo off

set "timeout=7"
set "threshold=1000"
set "caption=Added to log"

set "command=pwsh -NoProfile -Command """
set "command=%command%$dir = '%~dp0.\log\'"
set "command=%command%; if (-not (Test-Path $dir)) { mkdir $dir }"
set "command=%command%; $lastFile = Get-ChildItem $dir\*.log _bar_ Select-Object -Last 1"
set "command=%command%; if ($null -eq $lastFile -or (gc $lastFile).Count -gt %threshold%) {"
set "command=%command% $lastFile = Join-Path $dir ""quick_-_$(Get-Date -f yyyy-MM-dd-HHmmss).log"""
set "command=%command%} else {"
set "command=%command% $lastFile = $lastFile.FullName"
set "command=%command%}"

if "%~1" EQU "" goto :onlytoast
goto :addlog

:onlytoast
set "caption=Last log added"
goto :toast

:addlog
set "command=%command%; $myLog = """[$(Get-Date -f 'yyyy-MM-dd HH:mm:ss')] %COMPUTERNAME%/%USERNAME%: %*""""
set "command=%command%; Out-File -Path $lastFile -InputObject $myLog -Append"

:toast
set "command=%command%; . '%~dp0.\pwsh\Toast.ps1'"
set "command=%command%; Get-Content $lastFile _bar_ Select-Object -Last 1 _bar_ Out-Toast -Title '%caption%' -SuggestedTimeout %timeout%"
set "command=%command%"""

if "%~1" EQU "--whatif" goto :whatif
goto :execute

:whatif
echo %command:_bar_=^|%
exit /b

:execute
%command:_bar_=^|%

