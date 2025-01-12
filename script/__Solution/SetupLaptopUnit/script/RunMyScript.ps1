Param(
    [String]
    $Name,

    [String]
    $Message,

    [ScriptBlock]
    $ScriptBlock
)

$ErrorActionPreference = 'Stop'
. "$PsScriptRoot/MyScript.ps1"

Write-Output $Message

try {
    & $ScriptBlock
}
catch {
    Save-LastAction -Name $Name -Success $false
    throw $_
}

Save-LastAction -Name $Name -Success $true
