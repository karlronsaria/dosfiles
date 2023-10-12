<#
    .SYNOPSIS
        Disable UAC through powershell
        
    .DESCRIPTION
        Disable UAC through powershell
        
    .LINK
        https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_switch?view=powershell-7
#>

$os_version = (Get-CimInstance Win32_OperatingSystem).Version
$version = $os_version.Split(".")[0]

if ($version -eq 10)
{
    Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorAdmin" -Value "0"
}
elseif ($version -eq 6)
{
    $sub = $os_version.Split(".")[1]
    
    if ($sub -eq 0 -or $sub -eq 1)
    {
        Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableLUA" -Value "0"
    }
    else
    {
        Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorAdmin" -Value "0"
    }
}
elseif ($version -eq 5)
{
    Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableLUA" -Value "0"
}
else
{
    Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorAdmin" -Value "0"
}
