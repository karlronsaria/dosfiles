@echo off
copy "%~dp0.\res\unity.gitignore" "%cd%"
rename "%cd%\unity.gitignore" ".gitignore"
del "%cd%\unity.gitignore"
git init
git add .
git commit -m "first commit"
mkdir "%~dp0.\backup\"

for %%a in (%cd%) do (
    git bundle create "%~dp0.\backup\%%~na.bundle" --all
    REM git clone "%cd%" "%~dp0.\backup\%%~na"
)

