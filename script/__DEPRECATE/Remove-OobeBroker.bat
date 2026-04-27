@echo off

:: link: elevenforum.com
:: - url: <https://www.elevenforum.com/t/user-oobe-broker-always-running-in-background-how-to-disable.8275/>
:: - retrieved: 2026-04-24
takeown /s %computername% /u %username% /f "%WINDIR%\System32\oobe\UserOOBEBroker.exe"
icacls "%WINDIR%\System32\oobe\UserOOBEBroker.exe" /inheritance:r /grant:r %username%:F
taskkill /im UserOOBEBroker.exe /f
del "%WINDIR%\System32\oobe\UserOOBEBroker.exe" /s /f /q
echo Please restart your computer

