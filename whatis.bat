@echo off
set "cmd=pwsh -Command ""Import-DemandModule protect; Unprotect-Object -Query %1"""
%cmd%

