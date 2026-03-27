:: link: captive portal network triggers
:: - url
::   - <http://neverssl.com>
::   - <http://msftconnecttest.com>
:: - retrieved: 2026-02-14

@echo off

if "%~1" EQU "2" start http://msftconnecttest.com/redirect

if "%~2" EQU "3" goto :flushDnsAndrenewIp
goto :default

:flushDnsAndrenewIp
ipconfig /flushdns
ipconfig /release
ipconfig /renew

:default
start http://neverssl.com

