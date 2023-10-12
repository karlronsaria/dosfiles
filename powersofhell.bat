@echo off

title Windows Powers of Hell
set "res_dir=%~dp0.\res"
set "appname=powershell.exe"
set "coreapp=pwsh.exe -WorkingDirectory ~"
set "profile=%onedrive%\Documents\WindowsPowerShell\hellfile.ps1"
set "iconloadstr=%res_dir%\Set-ConsoleIcon.ps1 -IconFile %res_dir%\powersofhell.ico"

echo Loading...

setlocal EnableDelayedExpansion

set "next_arg_is_command=False"
set "isother=True"
set "command="
set "otherargs="
set "temp=%~1"

if "%temp%" == "" (
    set "appname=%appname% -NoExit"
    goto Continue
)

if "%temp:~0,1%" NEQ "-" (
    set "command=!temp!"
    shift
)

:Loop
if "%~1" == "" goto Continue

if "!command!" == "" (
    if "!next_arg_is_command!" == "True" (
        set "command=%~1"
        set "next_arg_is_command=False"
        set "isother=False"
    )

    set "temp=%~1"

    if "!temp:~0,1!" == "-" (
        ((echo -Command | find "%~1" > nul) || (echo -command | find "%~1" > nul)) && (
            set "next_arg_is_command=True"
            set "isother=False"
        )

        ((echo -Core | find "%~1" > nul) || (echo -core | find "%~1" > nul)) && (
            set "appname=%coreapp%"
        )
    )
)

if "!isother!" == "True" (
    set "otherargs=!otherargs! %1"
)

set "isother=True"
shift
goto Loop
:Continue

set "old_command=!command!"
set "command=& { Clear-HostLine; "

if "!old_command!" == "" (
    set "command=!command! . %profile%;"
    set "command=!command! %iconloadstr%;"
)

set "command=!command! !old_command!;"
set "command=!command! }"

!appname! -Command "!command!"!otherargs!

endlocal

