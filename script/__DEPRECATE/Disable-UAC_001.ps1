<#
    .SYNOPSIS
        Disable UAC through powershell
        
    .DESCRIPTION
        Disable UAC through powershell
        
    .LINK
        https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_switch?view=powershell-7
#>

$RegistryDisablePrompt = {
    Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorAdmin" -Value "0"
}

$RegistryDisableLua = {
    Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableLUA" -Value "0"
}

$os_version = (Get-CimInstance Win32_OperatingSystem).Version
$major_version = $os_version.Split(".")[0]

if ($major_version -eq 10)
{
    $RegistryDisablePrompt.Invoke()
}
elseif ($major_version -eq 6)
{
    $minor_version = $os_version.Split(".")[1]
    
    if ($minor_version -eq 0 -or $minor_version -eq 1)
    {
        $RegistryDisableLua.Invoke()
    }
    else
    {
        $RegistryDisablePrompt.Invoke()
    }
}
elseif ($major_version -eq 5)
{
    $RegistryDisableLua.Invoke()
}
else
{
    $RegistryDisablePrompt.Invoke()
}
