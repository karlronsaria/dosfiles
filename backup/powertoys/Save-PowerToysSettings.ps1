Param(
    [string]
    $Destination
)

function Save-PowerToysSettings {
    Param(
        [string]
        $Destination
    )

    if (-not $Destination) {
        $Destination = Get-Location
    }

    $Destination = Join-Path `
        -Path $Destination `
        -ChildPath 'setting'

    $src = "$($env:LocalAppData)\Microsoft\PowerToys\"

    Get-ChildItem -Path "$src/*.json" -Recurse |
    Foreach-Object {
        $name = $_.FullName.Replace($src, "")

        $dstPath = Join-Path `
            -Path $Destination `
            -ChildPath $name

        $parent = Split-Path `
            -Path $dstPath `
            -Parent

        if (-not (Test-Path -Path $parent)) {
            mkdir $parent -Force | Out-Null
        }

        Copy-Item `
            -Path $_.FullName `
            -Destination $dstPath `
            -Recurse `
            -Force
    }

    $readmePath = Join-Path `
        -Path $Destination `
        -ChildPath 'readme.md'

    # (karlr 2025-11-11): Uses DateTimeFormat
    $readmeBody = @"
# readme

- retrieved: $(Get-Date -f yyyy-MM-dd-HHmmss)
"@

    $readmeBody | Out-File `
        -FilePath $readmePath
}

Save-PowerToysSettings @PSBoundParameters

