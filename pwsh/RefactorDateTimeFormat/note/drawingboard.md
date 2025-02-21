# drawingboard

```powershell
demand GrepWalk

$walk = dir *.ps1 -Recurse | sls "yyyy_" | walk

$walk = dir *.ps1 -Recurse | sls DateFormat | walk

$walk = dir *.ps1 -Recurse | sls DateTimeFormat | walk

$walk = dir *.ps1 -Recurse | sls "(^|\W)_(\W|$)" | where { $_.Matches.Value | foreach { $_ -notmatch '\$_' } } | where Line -notmatch "DateFormat" | where Line -notmatch "DateTimeFormat" | walk

dir *.vim, *.lua, *.ps1, *.bat, *.ahk, *.ahk2, *.json, *.md, *.py -Recurse | sls "(^|\W)_(\W|$)" | where { $_.Matches.Value | foreach { $_ -notmatch '\$_' } }
```

## extensions

ahk
ahk2
bat
c
cpp
cs
css
h
hpp
html
java
js
json
lua
md
ps1
py
rb
rs
ts
vim
reg

