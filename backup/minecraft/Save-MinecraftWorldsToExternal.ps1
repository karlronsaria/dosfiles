# (karlr 2026-07-06): Good enough for now.
$worlds = @(
    "world-est-2025-08-16"
    "CreateMoreMoonwellsCreateMoreMoo"
    "i-like-this-village-please-reference"
    "BuildMoreBurrowsBuildMoreBurrows"
    "THSCHUTT NotreDame(1-1)+ BUILDv1.20.4 2025-04-05"
)

$srcDir = "$($env:APPDATA)/.minecraft/saves/"
$dstDir = "D:/__CURRENT/backup/minecraft"

if (-not (Test-Path $dstDir)) {
    "Whoops! Your destination path is not connected."
    ""
    "  D:/__CURRENT/backup/minecraft"
    ""
    return
}

foreach ($world in $worlds) {
    $src = Join-Path $srcDir $world

    # Uses DateTimeFormat
    $dst = "$(Join-Path $dstDir $world)-$(Get-Date -f yyyy-MM-dd-HHmmss).7z"
    7z a $dst $src
}

