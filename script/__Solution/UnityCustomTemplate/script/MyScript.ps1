function ConvertFrom-7zArchiveGzip {
    Param(
        [String]
        $Source,

        [String]
        $Destination,

        [ValidateSet('7z', 'bz2', 'gz', 'tar', 'wim', 'xz', 'zip')]
        [String]
        $Type = 'tar',

        [Switch]
        $Force,

        [Switch]
        $WhatIf
    )

    $app = "7z.exe"

    if (-not (Test-Path $Source -PathType Leaf)) {
        return "Source file not found"
    }

    if (-not $Destination) {
        $Destination = (Get-Item $Source).BaseName
    }

    $writeCmd = if ($Force) {
        " -aoa"
    }

    $cmd =
    "$app x `"$Source`" -so | $app x$writeCmd -si -t$Type -o`"$Destination`""

    if ($WhatIf) {
        return $cmd
    }

    iex $cmd
    Get-Item $Destination
}

function ConvertTo-7zArchiveGzip {
    Param(
        [String]
        $Source,

        [String]
        $Destination,

        [ValidateSet('7z', 'bz2', 'gz', 'tar', 'wim', 'xz', 'zip')]
        [String]
        $Type = 'tar',

        [Switch]
        $Force,

        [Switch]
        $WhatIf
    )

    $app = "7z.exe"

    if (-not (Test-Path $Source)) {
        return "Source file not found"
    }

    if (-not $Destination) {
        $Destination = (Get-Item $Source).BaseName
    }

    if ($Destination -notmatch "\.tgz$") {
        $Destination = "$Destination.tgz"
    }

    $srcItem = Get-Item $Source

    $files = switch ($srcItem) {
        { $_ -is [System.IO.FileInfo] } {
            $Source
        }

        { $_ -is [System.IO.DirectoryInfo] } {
            Join-Path $Source '*'
        }
    }

    $Source = $Source.BaseName

    $writeCmd = if ($Force) {
        " -aoa"
    }

    $cmd =
    "$app a -t$Type -so $Source.$Type `"$files`" | $app a$writeCmd -si -o`"$Destination.tgz`""

    if ($WhatIf) {
        return $cmd
    }

    iex $cmd
    Get-Item $Destination
}

function New-UnityProjectTemplate {
    [CmdletBinding(DefaultParameterSetName = "UseDefaultLocation")]
    Param(
        [Parameter(ParameterSetName = "UseDefaultLocation")]
        [ArgumentCompleter({
            Param($A, $B, $C)

            $setting = cat "$PsScriptRoot/../res/unitysolution.setting.json" |
                ConvertFrom-Json

            return $setting |
                foreach { iex $setting.TemplatesPath } |
                dir |
                foreach { Get-Item $_.FullName } |  # Required by PowerShell 5
                where { Test-Path $_ -PathType Leaf } |
                foreach { $_.Name } |
                where { $_ -like "$C*" } |
                foreach { "`"$_`"" }
        })]
        [String]
        $BaseTemplateName,

        [Parameter(ParameterSetName = "UseDefaultLocation")]
        [ArgumentCompleter({
            Param($A, $B, $C)

            $setting = cat "$PsScriptRoot/../res/unitysolution.setting.json" |
                ConvertFrom-Json

            return $setting |
                foreach { iex $setting.ProjectsPath } |
                dir |
                foreach { $_.Name } |
                where { $_ -like "$C*" } |
                foreach { "`"$_`"" }
        })]
        [String]
        $ProjectName,

        [Parameter(ParameterSetName = "UseDifferentLocation")]
        [String]
        $BaseTemplatePath,

        [Parameter(ParameterSetName = "UseDifferentLocation")]
        [String]
        $ProjectPath,

        [String]
        $NewName,

        [String]
        $NewDisplayName,

        [ValidateScript({
            $_ -match "(\d+(\.\d+)*)?"
        })]
        [String]
        $NewVersion,

        [String]
        $NewDescription,

        [Switch]
        $NoRearchive
    )

    $setting = cat "$PsScriptRoot/../res/unitysolution.setting.json" |
        ConvertFrom-Json

    $loadItemPathForm =
        -not $BaseTemplateName -or
        -not $ProjectName -or
        -not $BaseTemplatePath -or
        -not $ProjectPath

    $simpleWidth = 300
    $wideWidth = 500

    if ($loadItemPathForm) {
        $prefs = [PsCustomObject]@{
            Caption = "Select a project and base template"
            Width = $wideWidth
        }

        $menu = @(
            [PsCustomObject]@{
                Name = "BaseTemplateName"
                Text = "Select a base template"
                Type = "Enum"
                Mandatory = $true
                As = 'DropDown'
                To = 'Pair'
                Symbols =
                    $setting |
                    foreach { iex $setting.TemplatesPath } |
                    dir |
                    foreach { Get-Item $_.FullName } |  # Required by PowerShell 5
                    where { Test-Path $_ -PathType Leaf } |
                    foreach {
                        [PsCustomObject]@{
                            Text = $_.Name
                        }
                    }
            },
            [PsCustomObject]@{
                Name = "ProjectName"
                Text = "Select a project folder"
                Type = "Enum"
                Mandatory = $true
                As = 'DropDown'
                To = 'Pair'
                Symbols =
                    $setting |
                    foreach { iex $setting.ProjectsPath } |
                    dir |
                    foreach {
                        [PsCustomObject]@{
                            Text = $_.Name
                        }
                    }
            }
        )

        $result = $menu | Show-QformMenu `
            -Preferences $prefs

        return $result

        if (-not $result.Confirm) {
            return
        }

        $BaseTemplateName = $result.MenuAnswers.BaseTemplateName.Text
        $ProjectName = $result.MenuAnswers.ProjectName.Text

        if (-not $BaseTemplateName) {
            return "Base template name not found"
        }

        if (-not $ProjectName) {
            return "Project name not found"
        }
    }

    if (-not $BaseTemplatePath) {
        $templatesDir = $setting | foreach { iex $setting.TemplatesPath }
        $BaseTemplatePath = Join-Path $templatesDir $BaseTemplateName
    }

    if (-not $ProjectPath) {
        $projectsDir = $setting | foreach { iex $setting.ProjectsPath }
        $ProjectPath = Join-Path $projectsDir $ProjectName
    }

    $extractPath = Join-Path $env:temp (Get-Item $BaseTemplatePath).BaseName

    ConvertFrom-7zArchiveGzip `
        -Source $BaseTemplatePath `
        -Destination $extractPath `
        -Type 'tar' `
        -Force

    $packagePath = Join-Path $extractPath "$($setting.RequestEdit[0])"

    $package =
        $packagePath |
        Get-Item |
        cat |
        ConvertFrom-Json

    $loadInfoForm =
        -not $NewName -or
        -not $NewDisplayName -or
        -not $NewVersion -or
        -not $NewDescription

    $newTemplatePath = ''
    $caption = 'Write a package.json'
    $width = $simpleWidth

    while ($loadInfoForm) {
        Import-Module PsQuickform

        $prefs = [PsCustomObject]@{
            Caption = $caption
            Width = $width
        }

        $menu = @(
            [PsCustomObject]@{
                Text = 'Template Name (Must contain no spaces)'
                Name = 'TemplateName'
                Type = 'Field'
                Default =
                    if ($NewName) {
                        $NewName
                    }
                    else {
                        $package.name
                    }
            },
            [PsCustomObject]@{
                Text = 'Display Name'
                Type = 'Field'
                Default =
                    if ($NewDisplayName) {
                        $NewDisplayName
                    }
                    else {
                        $package.displayName
                    }
            },
            [PsCustomObject]@{
                Text = 'Version (0.0.0)'
                Name = 'Version'
                Type = 'Field'
                Default =
                    if ($NewVersion) {
                        $NewVersion
                    }
                    else {
                        $package.version
                    }
            },
            [PsCustomObject]@{
                Text = 'Description'
                Type = 'Field'
                Default =
                    if ($NewDescription) {
                        $NewDescription
                    }
                    else {
                        $package.description
                    }
            },
            [PsCustomObject]@{
                Text = 'Archive Immediately'
                Type = 'Check'
                Default = $true
            }
        )

        $result = $menu | Show-QformMenu `
            -Preferences $prefs

        if (-not $result.Confirm) {
            return
        }

        $answer = $result.MenuAnswers

        if ($answer.TemplateName) {
            $NewName = $answer.TemplateName
        }

        if ($answer.DisplayName) {
            $NewDisplayName = $answer.DisplayName
        }

        if ($answer.Version) {
            $NewVersion = $answer.Version
        }

        if ($answer.Description) {
            $NewDescription = $answer.Description
        }

        $NoRearchive = -not $answer.ArchiveImmediately

        $newTemplatePath = Join-Path `
            (Split-Path $BaseTemplatePath -Parent) `
            $NewName

        $loadInfoForm = $false
        $width = $wideWidth

        $newTemplateFullName =
            "$newTemplatePath-$NewVersion$($setting.ArchiveExtension)"

        if ($NewName -match "\s") {
            $caption = 'New template name cannot have spaces!'
            $loadInfoForm = $true
        }
        elseif ((Test-Path $newTemplateFullName)) {
            $caption = 'That version of that template already exists!'
            $loadInfoForm = $true
        }
        elseif ($NewVersion -notmatch "^\d+(\.\d+)*$") {
            $caption = 'New version must match number pattern (0.0.0)!'
            $loadInfoForm = $true
        }
    }

    $newTemplatePath = Join-Path `
        (Split-Path $BaseTemplatePath -Parent) `
        $NewName

    $newTemplateFullName =
        "$newTemplatePath-$NewVersion$($setting.ArchiveExtension)"

    $package.name = $NewName
    $package.displayName = $NewDisplayName
    $package.version = $NewVersion
    $package.description = $NewDescription

    $package |
        ConvertTo-Json |
        Out-File $packagePath -Force

    foreach ($replace in $setting.Replace) {
        Copy-Item `
            (Join-Path $ProjectPath $replace.Source) `
            (Join-Path $extractPath $replace.Destination) `
            -Recurse `
            -Force
    }

    return $BaseTemplatePath

    if (-not $NoRearchive) {
        ConvertTo-7zArchiveGzip `
            -Source $extractPath `
            -Destination $BaseTemplatePath `
            -Type 'tar' `
            -Force
    }
}

