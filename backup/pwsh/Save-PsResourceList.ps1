$fileName = 'psresource'
$ext = '.json'

if (Test-Path "$PsScriptRoot/$fileName$ext") {
    mkdir "$PsScriptRoot/__OLD" -ErrorAction SilentlyContinue

    # Uses DateTimeFormat
    Move-Item `
        -Path "$PsScriptRoot/$fileName"
        -Destination "$PsScriptRoot/__OLD/$fileName-$(Get-Date -f yyyy-MM-dd-HHmmss)$ext"
}

Get-PSResource |
    ConvertTo-Json -Depth 100 |
    Out-File -FilePath "$PsScriptRoot/$fileName$ext"

