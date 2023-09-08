function Convert-Ffmpeg {
    Param(
        [Parameter(ValueFromPipeline = $true)]
        $InputObject,

        [ValidateSet("gif")]
        [String]
        $To
    )

    $setting = cat "$PsScriptRoot/../res/setting.json" `
        | ConvertFrom-Json

    $app = $setting.AppLocation

    $itemName = switch ($InputObject) {
        { $_ -is [String] } {
            $InputObject
        }

        { $_ -is [System.IO.FileSystemInfo] } {
            $InputObject.Name
        }
    }

    $capture = [Regex]::Match($itemName, "^(?<name>.*)\.(?<ext>.*)$")
    $name = $capture.Groups['name'].Value `
        -replace ' ', '_'
    $ext = $capture.Groups['ext'].Value
    iex "$app -i ""$itemName"" $name.$To"
}
