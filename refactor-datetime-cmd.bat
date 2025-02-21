@echo off

echo Rename-DateTimeString -All '*', '*.*' -Recurse -Force
echo Replace-DateTimeString -All $(ext.bat^) -Recurse -Force
echo Replace-DateTimeString -All $(ext.bat^) -Recurse -Force -Target DateTimePattern
echo Replace-DateTimeString -All $(ext.bat^) -Recurse -Force -Target DatePattern
echo demand GrepWalk
echo $walk = dir *.* -Recurse ^| sls "_.* Uses DateTimeFormat" ^| Walk

