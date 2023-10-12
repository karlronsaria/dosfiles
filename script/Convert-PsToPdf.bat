@echo off

if %1/==/ goto help
if %2/==/ goto help

:run
set "dir=%ProgramFiles%\gs\gs9.53.3\lib"
set "cmd=%dir%\ps2pdf.bat"

if "%3"=="--reverse" (
  set "cmd=%dir%\pdf2ps.bat"
)

"%cmd%" %1 %2
goto :eof

:help
echo Usage:
echo   %~nx0 [options...] input.[e]ps output.pdf
echo   %~nx0 [options...] input.pdf output.[e]ps --reverse
goto :eof
