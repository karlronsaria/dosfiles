@echo off
pwsh -NoProfile -Command "Get-Process | ? Name -like ""*%~1*"" | Stop-Process -Force"

