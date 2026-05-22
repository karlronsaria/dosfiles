@echo off
powershell -NoProfile -Command ". %~dp0./script/unity.git.ps1; Save-UnityGitBundle"

