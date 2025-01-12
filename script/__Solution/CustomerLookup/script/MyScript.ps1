function Find-Customer {
    Param(
        [ArgumentCompleter({
            Param($A, $B, $C)

            $names = dir "$PsScriptRoot/../res/*.csv" | sort 'Name'

            if (@($names).Count -eq 0) {
                return
            }

            $names = $names[-1] |
                Get-Content |
                ConvertFrom-Csv |
                foreach { $_.'Child Name' }

            $suggest = $names | where {
                $_ -like "$C*"
            }

            return $(if (@($suggest).Count -eq 0) {
                $names
            }
            else {
                $suggest
            }) |
            foreach {
                "`"$_`""
            }
        })]
        [Parameter(ValueFromPipeline = $true)]
        [String]
        $Substring
    )

    Begin {
        $table = dir "$PsScriptRoot/../res/*.csv" | sort 'Name'

        if (@($table).Count -eq 0) {
            return
        }

        $table = $table[-1] |
            Get-Content |
            ConvertFrom-Csv
    }

    Process {
        $customers = $table | where {
            $_.'Child Name' -like "*$Substring*"
        } | foreach {
            [PsCustomObject]@{
                Name = $_.'Child Name'
                Email = $_.'First Parent Email'
            }
        }

        return [PsCustomObject]@{
            Substring = $Substring
            Customers = $customers
        }
    }
}

function Show-CustomerMultiplesWarning {
    Param(
        [Parameter(ValueFromPipeline = $true)]
        [PsCustomObject]
        $InputObject
    )

    Begin {
        $list = @()
        $multiples = @()
    }

    Process {
        $list += @($InputObject)
        $customers = $InputObject.Customers

        if (@($customers).Count -gt 1) {
            $multiples += @($InputObject)
        }
    }

    End {
        $result = if (@($multiples).Count -le 0) {
            $true
        } else {
            $message = ($multiples | foreach {
                $listStr = ($_.Customers | foreach {
                    "        $($_.Name) :`t$($_.Email)"
                }) `
                -join "`n"

                "  *$($_.Substring)*`n`n$listStr`n"
            }) `
            -join "`n"

            $title = "MyScript: Notice"
            $message =
                "Some of the names you queried have multiple matches:`n`n$message`nSend anyway?"

            Add-Type -AssemblyName 'PresentationCore', 'PresentationFramework'

            switch ([System.Windows.MessageBox]::Show($message, $title, "YesNo", "Exclamation")) {
                'Yes' { $true }
                'No' { $false }
            }
        }

        return [PsCustomObject]@{
            Success = $result
            List = $list
        }
    }
}

function Send-CustomerToClipboard {
    Param(
        [Parameter(ValueFromPipeline = $true)]
        [PsCustomObject]
        $InputObject,

        [String]
        $Property,

        [Switch]
        $Tee
    )

    $email = $InputObject.List.Customers.$Property

    if ($InputObject.Success) {
        Set-Clipboard $email
    }

    if ($Tee) {
        $email
    }
}

