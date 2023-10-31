CreateObject("Wscript.Shell").Run """" & _
    WScript.Arguments(0) & _
    """", 0, False

'# howto
'```
'wscript.exe "invisible.vbs" "mycommand.bat"
'```
'
'# link
'- url: https://superuser.com/questions/62525/run-a-batch-file-in-a-completely-hidden-way
'- retrieved: 2023_10_17
