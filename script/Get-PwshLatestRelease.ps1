Write-Progress `
    -Id 1 `
    -Activity "Running winget" `
    -PercentComplete 50

$table = winget search Microsoft.PowerShell |
    where { $_ -notmatch "^(\W|\s)*$" }

Write-Progress `
    -Id 1 `
    -Activity "Running winget" `
    -PercentComplete 100 `
    -Complete

foreach ($row in $table) {
    $captures = [Regex]::Matches($_, "\S+")

    $name = $captures[0].Value
    $id = $captures[1].Value
    $version = $captures[2].Value
    $source = $captures[3].Value

    if ($id -ne 'Microsoft.PowerShell') {
        continue
    }
}

$myVersion = $PsVersionTable.PsVersion
$upgradeAvailable = $false

$table | foreach {
    $captures = [Regex]::Matches($_, "\S+")

    $name = $captures[0].Value
    $id = $captures[1].Value
    $version = $captures[2].Value
    $source = $captures[3].Value
    $parts = $version.Split('.')

    $upgradeAvailable = $upgradeAvailable -or (
        $id -eq 'Microsoft.PowerShell' -and (
            [Int]$parts[0] -gt $myVersion.Major -or
            [Int]$parts[1] -gt $myVersion.Minor -or
            [Int]$parts[2] -gt $myVersion.Patch
        )
    )
}

if ($upgradeAvailable) {
    winget upgrade --id Microsoft.PowerShell --source winget
}

