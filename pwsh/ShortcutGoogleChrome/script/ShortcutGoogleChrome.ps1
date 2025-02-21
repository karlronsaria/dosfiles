function Run-ShortcutGoogleChromeProfile {
    [CmdletBinding(DefaultParameterSetName = "ByTags")]
    Param(
        [Parameter(ValueFromPipeline = $true)]
        [String[]]
        $Url,

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
        $ProfileId,

        [Switch]
        $DebugMode,

        [Switch]
        $ShowCommand
    )

    Begin {
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

        if ($DebugMode) {
            $command = "$command --remote-debugging-port=$($setting.RemoteDebuggingPort)"
        }

        $urls = ""
    }

    Process {
        $urls += ' ' + (($Url | foreach { "`"${psitem}`"" }) -join ' ')
    }

    End {
        $command = "$command$urls"

        return $(if ($ShowCommand) {
            $command
        }
        else {
            iex $command
        })
    }
}

function Stop-ShortcutGoogleChrome {
    $setting = Get-Item "$PsScriptRoot/../res/setting.json" |
        Get-Content |
        ConvertFrom-Json

    $dateTime = Get-Date -Format "yyyy-MM-dd-HHmmss" # Uses DateTimeFormat
    $filePath = "~/session_-_$($dateTime)_google-chrome-interrupt.onetab"
    $response = Invoke-RestMethod `
        -Uri "http://127.0.0.1:$($setting.RemoteDebuggingPort)/json" `
        -ErrorAction Continue

    if ($response) {
        $links = $response |
        foreach {
            $_.Url
        } |
        where {
            $_ -notmatch "^chrome|https?://ogs\.google\.com"
        }

        $links |
        Out-File `
            -FilePath $filePath `
            -Encoding utf8
    }

    taskkill /f /im chrome.exe

    if ($response) {
        "`nNew file: $($filePath)`n"
        $links
    }
    else {
        "`nNo sessions could be saved"
    }
}

function Open-ShortcutGoogleChromeSession {
    Param(
        $FilePath
    )

    if (-not (Test-Path $FilePath)) {
        return
    }

    $setting = Get-Content "$PsScriptRoot/../res/setting.json" `
        | ConvertFrom-Json

    Get-Item $FilePath |
    Get-Content |
    where { $_ } |
    foreach {
        $url = [regex]::Match($_, "[^|]+").Value
        Start-Process `
            -FilePath $setting.AppLocation `
            -ArgumentList $url
    }
}

