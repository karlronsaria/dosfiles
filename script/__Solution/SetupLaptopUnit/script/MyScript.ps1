function Get-Setting {
    Param(
        [String]
        $FileName = "setting.json"
    )

    return dir "$PsScriptRoot/../res/$FileName" `
        | cat `
        | ConvertFrom-Json
}

function Set-Setting {
    Param(
        [String]
        $FileName = "setting.json",

        [Parameter(ValueFromPipeline = $true)]
        [PsCustomObject]
        $InputObject
    )

    Process {
        $InputObject `
        | ConvertTo-Json `
        | Out-File `
            -FilePath "$PsScriptRoot/../res/$FileName" `
            -Encoding 'utf8' `
            -Force
    }
}

function New-MyLocalUser {
    foreach ($user in (Get-Setting).Users) {
        $password = $user.Password `
            | ConvertTo-SecureString `
                -AsPlainText `
                -Force

        New-LocalUser `
            -Name $user.Name `
            -FullName $user.Name `
            -Password $password `
            -AccountNeverExpires

        $groupName = switch ($user.Type) {
            'Admin' { 'Administrators' }
            default { 'Users' }
        }

        Add-LocalGroupMember `
            -Group $groupName `
            -Member $user.Name
    }

    Get-LocalUser
}

function Connect-MyWebProfile {
    Param(
        [Switch]
        $WhatIf
    )

    Import-Module "$PsScriptRoot\..\module\wifiprofilemanagement\1.1.0.0\WiFiProfileManagement.psd1"
    $web = (Get-Setting).WebProfile

    $password = ConvertTo-SecureString `
        -String $web.Password `
        -AsPlainText `
        -Force

    New-WiFiProfile `
        -ProfileName $web.ProfileName `
        -Authentication $web.Authentication `
        -Encryption $web.Encryption `
        -Password $password `
        -ConnectionMode 'auto'

    Connect-WiFiProfile `
        -ProfileName $web.ProfileName
}

function Install-Chocolatey {
    # link
    # - retrieved: 2023_06_06
    $url = 'https://community.chocolatey.org/install.ps1'

    Set-ExecutionPolicy 'Bypass' -Scope 'Process' -Force
    [System.Net.ServicePointManager]::SecurityProtocol =
        [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    iex ((New-Object System.Net.WebClient).DownloadString($url))
}

function Install-MyPackage {
    Param(
        [Switch]
        $WhatIf
    )

    $setting = Get-Setting
    $cmd = "choco install -y $($setting.Packages -join ' ')"

    if ($WhatIf) {
        return $cmd
    }

    iex $cmd
}

function Save-LastAction {
    Param(
        [String]
        $Name,

        [Boolean]
        $Success = $true
    )

    $session = Get-Setting -FileName "session.json"

    $session.LastAction = [PsCustomObject]@{
        Name = $Name
        Time = Get-Date -Format 'yyyy_MM_dd_HHmmss' # Uses DateTimeFormat
        Success = $Success
    }

    $session | Set-Setting -FileName "session.json"
}

function Save-CurrentLoginUser {
    $session = Get-Setting -FileName "session.json"
    $session.LastLogin = [Environment]::UserName
    $session | Set-Setting -FileName "session.json"
}

function Remove-LastLoginUser {
    Param(
        [Switch]
        $WhatIf
    )

    $session = Get-Setting -FileName "session.json"
    $cmd = "Get-LocalUser -Name '$($session.LastLogin)' | Remove-LocalUser"

    if ($WhatIf) {
        return $cmd
    }

    iex $cmd
}

function Add-ItemToStartMenu {
    Param(
        [String]
        $FullName,

        [Switch]
        $Debug
    )

    $namespace = Split-Path $FullName -Parent
    $itemName = Split-Path $FullName -Leaf
    $shell = New-Object -ComObject "Shell.Application"
    $folder = $shell.Namespace($namespace)
    $item = $folder.ParseName($itemName)

    $verb = $item.Verbs() | where {
        $_.Name -like '*Pin to Start*'
    }

    if ($Debug) {
        return [PsCustomObject]@{
            Namespace = $namespace
            ItemName = $itemName
            Folder = $folder
            Item = $item
            Verb = $verb
        }
    }

    if ($verb) {
        @($verb)[0].DoIt()
    }
}



