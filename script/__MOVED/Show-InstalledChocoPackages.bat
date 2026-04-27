@echo off
set log=%ProgramData%\chocolatey\logs\chocolatey.log 
type %log% | findstr /c:"Successfully installed" 
