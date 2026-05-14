<#
.LINK
* SomeOrdinaryGamers - Delete Google Chrome Right Now
  - Url: <https://www.youtube.com/watch?v=Fx46DedxWAY>
  - Retrieved: 2026-05-06
#>
function Start-ShortcutGoogleChromeProfile {
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
        [Alias('p', 't', 'Tag')]
        [String[]]
        $ProfileTags,

        [ArgumentCompleter({
            $setting = Get-Content "$PsScriptRoot/../res/setting.json" `
                | ConvertFrom-Json

            return $setting.Profiles.Id
        })]
        [Parameter(ParameterSetName = "ById")]
        [Alias('Id')]
        [Int]
        $ProfileId,

        [Switch]
        $DebugMode,

        [Switch]
        $ShowCommand
    )

    Begin {
        # link: SomeOrdinaryGamers - Delete Google Chrome Right Now
        # - url: <https://www.youtube.com/watch?v=Fx46DedxWAY>
        # - retrieved: 2026-05-06
        function Remove-CompulsoryMalware {
            @(
                "${env:LOCALAPPDATA}/Google/Chrome/User Data/OptGuideOnDeviceModel"
            ) |
            Get-Item -ErrorAction SilentlyContinue |
            ForEach-Object {
                $_
                Remove-Item $_.FullName -Force -Recurse
            }

            return $null
        }

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

        $setting = Get-Content "$PsScriptRoot/../res/setting.json" |
            ConvertFrom-Json

        if ($PsCmdlet.ParameterSetName -eq "ByTags") {
            $haystack = $setting.Profiles
            $needles = @()

            foreach ($tag in $ProfileTags) {
                $needles += @($haystack | Where-Object {
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
        $urls += ' ' + (($Url | ForEach-Object { "`"${psitem}`"" }) -join ' ')
    }

    End {
        $command = "$command$urls"

        return $(if ($ShowCommand) {
            $command
        }
        else {
            Invoke-Expression $command
            $stop = [System.Diagnostics.Stopwatch]::StartNew()

            # (karlr 2026-05-06)
            while (-not (Remove-CompulsoryMalware) -and $stop.Elapsed.TotalSeconds -lt 3) {
                Start-Sleep -Milliseconds 100
            }
        })
    }
}

function Get-ShortcutGoogleChromeLink {
    $setting = Get-Item "$PsScriptRoot/../res/setting.json" |
        Get-Content |
        ConvertFrom-Json

    $response = Invoke-RestMethod `
        -Uri "https://127.0.0.1:$($setting.RemoteDebuggingPort)/json" `
        -ErrorAction Continue

    $response |
        ForEach-Object {
            $_.Url
        } |
        Where-Object {
            $_ -notmatch "^chrome|https?://ogs\.google\.com"
        }
}

function Stop-ShortcutGoogleChrome {
    $setting = Get-Item "$PsScriptRoot/../res/setting.json" |
        Get-Content |
        ConvertFrom-Json

    $dateTime = Get-Date -Format "yyyy-MM-dd-HHmmss" # Uses DateTimeFormat
    $filePath = "~/session_-_$($dateTime)_google-chrome-interrupt.onetab"
    $response = Invoke-RestMethod `
        -Uri "https://127.0.0.1:$($setting.RemoteDebuggingPort)/json" `
        -ErrorAction Continue

    if ($response) {
        $links = $response |
        ForEach-Object {
            $_.Url
        } |
        Where-Object {
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
    Where-Object { $_ } |
    ForEach-Object {
        $url = [regex]::Match($_, "[^|]+").Value
        Start-Process `
            -FilePath $setting.AppLocation `
            -ArgumentList $url
    }
}

