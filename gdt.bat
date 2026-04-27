@echo off
for /f %%i in ('wmic os get localdatetime ^| find "."') do set dt=%%i
:: Uses DateTimeFormat
echo %dt:~0,4%-%dt:~4,2%-%dt:~6,2%-%dt:~8,6%

