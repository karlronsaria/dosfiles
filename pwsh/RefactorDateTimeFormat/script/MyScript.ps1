function Rename-DateTimeString {
    Param(
        [Parameter(
            ParameterSetName = 'ByFilePath',
            ValueFromPipeline = $true
        )]
        [String[]]
        $FilePath,

        [ArgumentCompleter({
            Param($A, $B, $C)

            $ext = Get-ChildItem `
                    -Recurse |
                Select-Object `
                    -ExpandProperty Extension `
                    -Unique

            $patterns = $ext | foreach { "*$_" }

            $suggest = $patterns |
                where {
                    $_ -like "$C*"
                }

            return $(
                if ($null -eq $suggest -or @($suggest).Count -eq 0) {
                    $patterns
                }
                else {
                    $suggest
                }
            )
        })]
        [Parameter(
            ParameterSetName = 'ByFilePattern'
        )]
        [String[]]
        $All = @('*', '*.*'),

        [String]
        $ReferenceSeparator = '_',

        [String]
        $DifferenceSeparator = '-',

        [Switch]
        $Force,

        [Parameter(
            ParameterSetName = 'ByFilePattern'
        )]
        [Switch]
        $Recurse
    )

    Begin {
        if ($PsCmdlet.ParameterSetName -eq 'ByFilePattern') {
            return Get-ChildItem $All -Recurse:$Recurse | Rename-DateTimeString -Force
        }

        $beforeList = @()
        $afterList = @()
    }

    Process {
        if ($PsCmdlet.ParameterSetName -eq 'ByFilePattern') {
            return
        }

        try {
            foreach ($path in @($FilePath | where { $_ })) {
                $item = Resolve-Path $path |
                    Get-Item

                $before = $item.FullName

                $name = $item.Name | Replace-DateTimeString `
                    -ReferenceSeparator:$ReferenceSeparator `
                    -DifferenceSeparator:$DifferenceSeparator

                if ($name -eq $item.Name) {
                    continue
                }

                $after = Rename-Item `
                    -Path $before `
                    -NewName $name `
                    -Force:$Force `
                    -PassThru

                $after = $after.FullName
                $beforeList += @($before)
                $afterList += @($after)
            }
        }
        catch {
            throw $_
        }
    }

    End {
        if ($PsCmdlet.ParameterSetName -eq 'ByFilePattern') {
            return
        }

        $diff = Compare-DateTimeString `
            -Ref $beforeList `
            -Dif $afterList

        if ($null -eq $diff) {
            Write-Output "No changes were made."
            return
        }

        $diff

        if (-not $diff.Success) {
            Write-Error "Something went wrong."
            return
        }
    }
}

function Replace-DateTimeString {
    Param(
        [Parameter(
            ParameterSetName = 'ByCat',
            ValueFromPipeline = $true
        )]
        $InputObject,

        [Parameter(
            ParameterSetName = 'ByFilePath'
        )]
        [String]
        $FilePath,

        [ArgumentCompleter({
            Param($A, $B, $C)

            $ext = Get-ChildItem `
                    -Recurse |
                Select-Object `
                    -ExpandProperty Extension `
                    -Unique

            $patterns = $ext | foreach { "*$_" }

            $suggest = $patterns |
                where {
                    $_ -like "$C*"
                }

            return $(
                if ($null -eq $suggest -or @($suggest).Count -eq 0) {
                    $patterns
                }
                else {
                    $suggest
                }
            )
        })]
        [Parameter(
            ParameterSetName = 'ByFilePattern'
        )]
        [String[]]
        $All = @('*.md', '*.json', '*.ps1', '*.bat', '*.txt', '*.html', '*.py'),

        [String]
        $ReferenceSeparator = '_',

        [String]
        $DifferenceSeparator = '-',

        [Parameter(
            ParameterSetName = 'ByFilePath'
        )]
        [Parameter(
            ParameterSetName = 'ByFilePattern'
        )]
        [Switch]
        $Force,

        [Parameter(
            ParameterSetName = 'ByFilePattern'
        )]
        [Switch]
        $Recurse,

        [ValidateSet('Date', 'DatePattern', 'DateTimePattern')]
        [String]
        $Target = 'Date'
    )

    Begin {
        $patternParts =
            switch ($Target) {
                'DatePattern' {
                    'yyyy', 'MM', 'dd'
                    break
                }

                'DateTimePattern' {
                    "yyyy", "MM", "dd", "HHmmss"
                    break
                }

                'Date' {
                    "\d{4}", "\d{2}", "\d{2}(", "\d{2,6})?"
                    break
                }
            }

        $pattern = $patternParts -join $ReferenceSeparator

        switch ($PsCmdlet.ParameterSetName) {
            'ByFilePattern' {
                $activity = "Replacing all instances of '$pattern'"
                $allFiles = Get-ChildItem $All -Recurse:$Recurse

                $results = $allFiles |
                    foreach -Begin {
                        $count = 0
                    } -Process {
                        Write-Progress `
                            -Activity $activity `
                            -Status (Get-Item $_).Name `
                            -PercentComplete (100 * $count / $allFiles.Count)

                        $result = Replace-DateTimeString `
                            -FilePath $_ `
                            -Force:$Force `
                            -Target:$Target

                        $result | Add-Member `
                            -MemberType NoteProperty `
                            -Name File `
                            -Value $_

                        $result
                        $count++
                    } -End {
                        Write-Progress `
                            -Activity $activity `
                            -PercentComplete 100 `
                            -Completed
                    }

                return $results
            }

            'ByFilePath' {
                try {
                    $before = Resolve-Path $FilePath |
                        Get-Item |
                        Get-Content

                    $after = $before |
                        Replace-DateTimeString `
                            -Target:$Target

                    $diff = Compare-DateTimeString -Ref $before -Dif $after

                    if ($null -eq $diff) {
                        Write-Output "No changes were made. Write to file $FilePath will not continue."
                        return
                    }

                    $diff

                    if (-not $diff.Success) {
                        Write-Error "Something went wrong. Write to file $FilePath could not continue."
                        return
                    }

                    $after | Set-Content `
                        -Path $FilePath `
                        -Force:$Force
                }
                catch {
                    throw
                }

                return
            }
        }
    }

    Process {
        foreach ($line in $InputObject) {
            $captures = [regex]::Matches($_, $pattern)

            foreach ($capture in $captures) {
                $newDateTime = $capture.Value -replace $ReferenceSeparator, $DifferenceSeparator
                $line = $line -replace $capture, $newDateTime
            }

            $line
        }
    }
}

function Compare-DateTimeString {
    Param(
        [String[]]
        $ReferenceObject,

        [String[]]
        $DifferenceObject
    )

    if (@($ReferenceObject).Count -eq 0 -and @($DifferenceObject).Count -eq 0) {
        return $null
    }

    $lineCountsMatch = @($ReferenceObject).Count -eq @($DifferenceObject).Count

    $leftChars = (@($ReferenceObject) | Out-String) -split ''
    $rghtChars = (@($DifferenceObject) | Out-String) -split ''

    $charCountsMatch = @($leftChars).Count -eq @($rghtChars).Count

    $diff = Compare-Object -Ref $leftChars -Dif $rghtChars

    $left = $diff | where { $_.SideIndicator -like '<*' }
    $rght = $diff | where { $_.SideIndicator -like '*>' }

    $diffCountsMatch = @($left).Count -eq @($rght).Count

    # $leftValue = [int][char]$ReferenceSeparator
    # $rghtValue = [int][char]$DifferenceSeparator

    # $leftAvgValue = $left.
    #     InputObject |
    #     foreach {
    #         [int][char]$_
    #     } |
    #     measure -Sum |
    #     foreach {
    #         $_.Sum / $leftValue.Count
    #     }

    # $leftAvgValueMatchesSeparator = $leftAvgValue -eq $leftValue

    # $rghtAvgValue = $rght.
    #     InputObject |
    #     foreach {
    #         [int][char]$_
    #     } |
    #     measure -Sum |
    #     foreach {
    #         $_.Sum / $rghtValue.Count
    #     }

    # $rghtAvgValueMatchesSeparator = $rghtAvgValue -eq $rghtValue

    $success =
        $lineCountsMatch -and
        $charCountsMatch -and
        $diffCountsMatch
        # $leftAvgValueMatchesSeparator -and
        # $rghtAvgValueMatchesSeparator

    [pscustomobject]@{
        Success = $success
        LineCountsMatch = $lineCountsMatch
        CharCountsMatch = $charCountsMatch
        DiffCountsMatch = $diffCountsMatch
        # LeftAvgValueMatchesSeparator = $leftAvgValueMatchesSeparator
        # RightAvgValueMatchesSeparator = $rghtAvgValueMatchesSeparator
        # LeftChars = $leftChars
        # RghtChars = $rghtChars
    }
}

