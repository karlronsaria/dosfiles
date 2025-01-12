function New-MyLocalUser {
    $users = @(
        [PsCustomObject]@{
            Name = ""
            Password = ""
            Type = "User"
        },
        [PsCustomObject]@{
            Name = "Admin"
            Password = ""
            Type = "Admin"
        }
    )

    foreach ($user in $users) {
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

