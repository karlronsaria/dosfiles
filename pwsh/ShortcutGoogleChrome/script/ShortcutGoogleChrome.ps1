function Run-ShortcutGoogleChromeProfile {
    [CmdletBinding(DefaultParameterSetName = "ByTags")]
    Param(
        [Parameter(
            ParameterSetName = "ByTags",
            Position = 0
        )]
        [ArgumentCompleter({
            $setting = Get-Content "$PsScriptRoot/../res/setting.json" `
                | ConvertFrom-Json

            return $setting.Profiles.Tags
        })]
        [String[]]
        $ProfileTags,

        [ArgumentCompleter({
            $setting = Get-Content "$PsScriptRoot/../res/setting.json" `
                | ConvertFrom-Json

            return $setting.Profiles.Id
        })]
        [Parameter(ParameterSetName = "ById")]
        [Int]
        $ProfileId
    )

    function ConvertTo-ShortcutGoogleChromeProfileName {
        Param(
            [Int]
            $ProfileId
        )

        $temp = switch ($ProfileId) {
            0 { "Default" }
            default { "Profile $ProfileId" }
        }

        return $temp
    }

    function Get-ShortcutGoogleChromeProfileCommand {
        Param(
            [String]
            $AppLocation,

            [String]
            $ProfileName
        )

        return "& `"$AppLocation`" --args --profile-directory=`"$ProfileName`""
    }

    $setting = Get-Content "$PsScriptRoot/../res/setting.json" `
        | ConvertFrom-Json

    if ($PsCmdlet.ParameterSetName -eq "ByTags") {
        $haystack = $setting.Profiles
        $needles = @()

        foreach ($tag in $ProfileTags) {
            $needles += @($haystack | where {
                $tag -in $_.Tags
            })
        }

        $ProfileId = if ($null -eq $needles -or @($needles).Count -eq 0) {
            $setting.DefaultProfileId
        } else {
            $needles[0].Id
        }
    }

    $profileName = ConvertTo-ShortcutGoogleChromeProfileName `
        -ProfileId $ProfileId

    $command = Get-ShortcutGoogleChromeProfileCommand `
        -AppLocation $setting.AppLocation `
        -ProfileName $profileName

    return iex $command
}
