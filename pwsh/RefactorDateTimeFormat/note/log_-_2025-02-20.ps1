cd \dev
cd pwsh
ls
cd .\RefactorDateTimeFormat\
ls
start nvim .\MyScript.ps1
start nvim .\MyScript.ps1
ls
rni mynote mynote_old_2025-02-20
ls
git clone $env:GitProfile/mynote
ls
. .\mynote\
. .\MyScript.ps1
ls
cd .\mynote\
ls
dir .\howto\*.md -Recurse | sls replace
dir .\howto\*.md -Recurse | sls replace | what 1
dir .\howto\*.md -Recurse | sls replace | what 1 | edit
dir .\howto\*.md -Recurse | sls datetime
dir .\howto\*.md -Recurse | sls format
es ".*consolehosthistory.*"
es ".*console.*host.*history.*"
es ".*console.*host.*"
es ".*console.*"
es -r ".*console.*"
es -r ".*consolehost.*"
es -r ".*consolehost_history.*"
es -r ".*consolehost_history_backup"
es -r ".*consolehost_history_backup" | cat | sls "Replace-DateTimeString"
es -r ".*consolehost_history_backup" | cat | where { $_ -match "Replace-DateTimeString" }
es -r ".*consolehost_history_backup" | dir | cat | sls "Replace-DateTimeString"
get-clipboard > ..\case_-_2025-02-20.md
start nvim ..\case_-_2025-02-20.md
es -r ".*consolehost_history_backup" | dir | cat | sls "Rename-DateTimeString"
es -r ".*consolehost_history_backup" | dir | cat | sls "Rename-DateTimeString" | what -1
es -r ".*consolehost_history_backup" | dir | cat | sls "Rename-DateTimeString" | what -1 | clip
Get-Clipboard >> ..\case_-_2025-02-20.md
cd ..
. .\MyScript.ps1
cd .\mynote\
ls
Replace-DateTimeString -All *.md, *.json, *.ps1, *.bat, *.txt -Force -Recurse
cd ..
. .\MyScript.ps1
cd .\mynote\
dir *.* -Recurse | what Extension | select -Unique
dir *.* -Recurse | where Extension -eq '.eml'
dir *.* -Recurse | where Extension -eq '.html'
dir *.* -Recurse | where Extension -eq '.html' | edit
.\drawingboard_-_2025_01_29_python\
Replace-DateTimeString -All *.md, *.json, *.ps1, *.bat, *.txt, *.html -Force -Recurse
cd ..
. .\MyScript.ps1
cd .\mynote\
ls
Replace-DateTimeString -All *.md, *.json, *.ps1, *.bat, *.txt, *.html -Force -Recurse
dir *.md, *.json, *.ps1, *.bat, *.txt, *.html -Recurse | Rename-DateTimeString -Force
ls
start nvim .\pool_-_2024-09-30_Master.md
'*.md, *.json, *.ps1, *.bat, *.txt, *.html' | clip
'dir *.md, *.json, *.ps1, *.bat, *.txt, *.html -Recurse | Rename-DateTimeString -Force' | clip
cd ..
. .\MyScript.ps1
. .\MyScript.ps1
cd .\mynote\
ls
dir *.md, *.json, *.ps1, *.bat, *.txt, *.html -Recurse | sls yyyy_MM_dd
dir *.md, *.json, *.ps1, *.bat, *.txt, *.html -Recurse | sls yyyy_MM_dd | edit
Get-ProfileLocation -Default | cd
ls
cd .\Scripts\
ls
dir *.* -Recurse | what Extension | select -Unique
dir *.* -Recurse | where Extension -eq '.sample'
dir *.* -Recurse | where Extension -eq '.vscode'
dir *.* -Recurse | where Extension -eq '.idx'
dir *.* -Recurse | where Extension -eq '.pack'
dir *.* -Recurse | where Extension -eq '.rev'
dir *.* -Recurse | where Extension -eq '.reg'
dir *.* -Recurse | where Extension -eq '.reg' | sls yyyy_MM_dd
dir *.* -Recurse | where Extension -eq '.reg' | sls "\d{4}_"
dir *.* -Recurse | where Extension -eq '.reg' | sls "\d{s}_"
dir *.* -Recurse | where Extension -eq '.reg' | sls "\d{2}_"
ext.bat
ext.bat | what 1
$(ext.bat)
. C:\dev\pwsh\RefactorDateTimeFormat\MyScript.ps1
Replace-DateTimeString -All $(ext.bat) -Recurse -Force
Rename-DateTimeString -All $(ext.bat) -Recurse -Force
dir *.* -Recurse | where FullName -match "\d{4}_\d{2}_\d{2}"
Rename-DateTimeString -All *.* -Recurse -Force
dir *.* -Recurse | where FullName -match "\d{4}_\d{2}_\d{2}"
Rename-DateTimeString -All * -Recurse -Force
dir * -Recurse | where FullName -match "\d{4}_\d{2}_\d{2}"
dir *, *.* -Recurse | where FullName -match "\d{4}_\d{2}_\d{2}"
ls
dir $(ext) -Recurse | sls yyyy_
. C:\dev\pwsh\RefactorDateTimeFormat\MyScript.ps1
Replace-DateTimeString -All $(ext.bat) -Recurse -Force -TargetDateTimePattern
dir $(ext) -Recurse | sls yyyy_
. C:\dev\pwsh\RefactorDateTimeFormat\MyScript.ps1
Replace-DateTimeString -All $(ext.bat) -Recurse -Force -Target DateTimePattern
. C:\dev\pwsh\RefactorDateTimeFormat\MyScript.ps1
Replace-DateTimeString -All $(ext.bat) -Recurse -Force -Target DateTimePattern
Replace-DateTimeString -All $(ext.bat) -Recurse -Force -Target DateTime
Replace-DateTimeString -All $(ext.bat) -Recurse -Force -Target DatePattern
dir *.* -Recurse | sls "_.* Uses DateTimeFormat"
get-command *-*grep*
demand GrepWalk
$walk = dir *.* -Recurse | sls "_.* Uses DateTimeFormat" | Walk
$walk.Next()
$walk.Next()
$walk.Next()
$walk.Next()
$walk.Next()
$walk.Next()
$walk.Next()
$walk.Next()
$walk.Next()
$walk.Next()
$walk.Next()
$walk.Next()
$walk.Next()
$walk.Next()
$walk.Next()
$walk.Next()
$walk.Next()
$walk.Next()
start nvim .\PsTool\res\msexcel.setting.json
$walk.Next()
$walk.Next()
$walk.Next()
$walk.Next()
$walk.Next()
$walk.Next()
$walk.Next()
$walk.Next()
$walk.Next()

