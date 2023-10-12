:: Source:
::   https://serverfault.com/questions/294787/how-do-i-force-sync-the-time-on-windows-workstation-or-server
:: Retrieved:
::   2020_03_02
:: Requires:
::   RunAsAdministrator

@echo off

w32tm /unregister
w32tm /register
net stop w32time
net start w32time
w32tm /resync
w32tm /query /status
