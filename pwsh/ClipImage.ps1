<#
.SYNOPSIS
From PsMarkdown
#>
function New-ResourceDirectory {
    # Needed for ``-ErrorAction SilentyContinue``
    [CmdletBinding()]
    Param(
        [String]
        $BasePath = (Get-Location).Path,

        [String]
        $FolderName,

        [Switch]
        $WhatIf
    )

    if ([String]::IsNullOrWhiteSpace($FolderName)) {
        $setting = Get-Item "$PsScriptRoot/../res/setting.json" |
            Get-Content |
            ConvertFrom-Json

        $FolderName = $setting.ResourceDir
    }

    $BasePath = Join-Path $BasePath $FolderName

    if (-not (Test-Path $BasePath)) {
        $null = New-Item `
            -Path $BasePath `
            -ItemType Directory `
            -WhatIf:$WhatIf

        if (-not $WhatIf -and -not (Test-Path $BasePath)) {
            Write-Error "Failed to find/create subdirectory '$FolderName'"
            return
        }
    }

    return $BasePath
}

function Get-ClipboardFormat {
    # Needed for ``-ErrorAction SilentyContinue``
    [CmdletBinding()]
    Param()

    Add-Type -AssemblyName System.Windows.Forms
    $assembly = [System.Windows.Forms.Clipboard]

    $types = @(
        'Image'
        'FileDropList'
        'Text'
    )

    foreach ($type in $types) {
        if ($assembly::"Contains$type"()) {
            return [PsCustomObject]@{
                Success = $true
                Format = $type
                Clip = $assembly::"Get$type"()
            }
        }
    }

    return [PsCustomObject]@{
        Success = $false
        Format = "Text"
        Clip = ""
    }
}

<#
.SYNOPSIS
From PsMarkdown
#>
function New-MarkdownLink {
    # Needed for ``-ErrorAction SilentyContinue``
    [CmdletBinding()]
    Param(
        [String]
        $FolderName,

        [String]
        $BaseName,

        [String]
        $ItemName,

        [String]
        $LinkName,

        [String]
        $Format,

        [PsCustomObject]
        $ErrorObject,

        [Switch]
        $WhatIf
    )

    if (-not $WhatIf -and -not (Test-Path $ItemName)) {
        Write-Error "Failed to save image to '$ItemName'"
        return $ErrorObject
    }

    # (karlr 2021-11-25): This new line necessary for rendering with
    # typora-0.11.18
    $item_path = Join-Path "." $FolderName
    $item_path = Join-Path $item_path $BaseName

    return [PsCustomObject]@{
        Success = $true
        Path = $ItemName
        MarkdownString = "![$LinkName]($($item_path.Replace('\', '/')))"
        Format = $Format
    }
}

<#
.SYNOPSIS
From PsMarkdown
#>
function Save-ClipboardToImageFormat {
    # Needed for ``-ErrorAction SilentyContinue``
    [CmdletBinding()]
    Param(
        [String]
        $BasePath = (Get-Location).Path,

        [String]
        $FolderName = "res",

        [String]
        $FileName = (Get-Date -Format "yyyy-MM-dd-HHmmss"), # Uses DateTimeFormat

        [String]
        $FileExtension = ".png",

        [Switch]
        $Force,

        [Switch]
        $WhatIf,

        [ArgumentCompleter({
            Param($A, $B, $C)

            return [System.IO.FileInfo].DeclaredProperties.Name |
                where {
                    $_ -like "$C*"
                }
        })]
        [ValidateScript({
            $_ -in [System.IO.FileInfo].DeclaredProperties.Name
        })]
        [String]
        $OrderFileDropListBy = 'Name'
    )

    function Save-FileByTextClip {
        Param(
            [String]
            $InputObject,

            [Switch]
            $WhatIf
        )

        if (-not (Test-Path $InputObject)) {
            Write-Error "No file found at $InputObject"

            return [PsCustomObject]@{
                Success = $false
                BaseName = ""
                ItemName = ""
                LinkName = ""
            }
        }

        $base_name = Split-Path $InputObject -Leaf
        $item_name = Join-Path $BasePath $base_name
        $link_name = $base_name

        if (-not $WhatIf) {
            Copy-Item $InputObject $item_name -Force:$Force
        }

        return [PsCustomObject]@{
            Success = $true
            BaseName = $base_name
            ItemName = $item_name
            LinkName = $link_name
        }
    }

    $obj = [PsCustomObject]@{
        Success = $false
        Path = ""
        MarkdownString = ""
        Format = 'Text'
    }

    $result = Get-ClipboardFormat
    $obj.Success = $result.Success
    $obj.Format = $result.Format

    if (-not $result.Success) {
        return $obj
    }

    $clip = $result.Clip

    $BasePath = New-ResourceDirectory `
        -BasePath $BasePath `
        -FolderName $FolderName `
        -WhatIf:$WhatIf

    if ($null -eq $BasePath) {
        return $obj
    }

    $item_name = ""

    switch ($obj.Format) {
        "FileDropList" {
            $objects = @()

            foreach ($item in $clip | Sort-Object -Property $OrderFileDropListBy) {
                $base_name = $item.Name
                $item_name = Join-Path $BasePath $base_name
                $link_name = $base_name

                if (-not $WhatIf) {
                    switch ($item) {
                        { $_ -is [String] } {
                            $result = Save-FileByTextClip `
                                -InputObject $clip `
                                -WhatIf:$WhatIf

                            if (-not $result.Success) {
                                return $obj
                            }

                            $base_name = $result.BaseName
                            $item_name = $result.ItemName
                            $link_name = $result.LinkName
                        }

                        default {
                            [void] $item.CopyTo($item_name, $Force)
                        }
                    }
                }

                $objects += @(New-MarkdownLink `
                    -FolderName $FolderName `
                    -BaseName $base_name `
                    -ItemName $item_name `
                    -LinkName $link_name `
                    -Format $obj.Format `
                    -ErrorObject $obj `
                    -WhatIf:$WhatIf
                )
            }

            return $objects
        }

        "Image" {
            $base_name = "$FileName$FileExtension"
            $item_name = Join-Path $BasePath $base_name
            $link_name = $FileName

            if (-not $WhatIf) {
                $clip.Save($item_name)
            }
        }

        "Text" {
            $result = Save-FileByTextClip `
                -InputObject $clip `
                -WhatIf:$WhatIf

            if (-not $result.Success) {
                # # (karlr 2025-02-22): I don't know why this line is here.
                # return $obj

                return [pscustomobject]@{
                    Success = $false
                    Path = ''
                    MarkdownString = ''
                    Format = $obj.Format
                }
            }

            $base_name = $result.BaseName
            $item_name = $result.ItemName
            $link_name = $result.LinkName
        }
    }

    return New-MarkdownLink `
        -FolderName $FolderName `
        -BaseName $base_name `
        -ItemName $item_name `
        -LinkName $link_name `
        -Format $obj.Format `
        -ErrorObject $obj `
        -WhatIf:$WhatIf
}

<#
.SYNOPSIS
From PsMarkdown
#>
function Move-ToTrashFolder {
    Param(
        [String]
        $Path,

        [String]
        $TrashFolder = "__OLD"
    )

    $Path = Join-Path (Get-Location) $Path
    $parent = Split-Path $Path -Parent
    $leaf = Split-Path $Path -Leaf
    $trash = Join-Path $parent $TrashFolder

    if ((Test-Path $Path)) {
        if (-not (Test-Path $trash)) {
            mkdir $trash -Force | Out-Null
        }

        Move-Item $Path $trash -Force | Out-Null
    }

    Get-Item (Join-Path $trash $leaf)
}

