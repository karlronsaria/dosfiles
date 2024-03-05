#Requires -RunAsAdministrator

<#
.SYNOPSIS
Permanantly and forcefully removes Microsoft Edge, and attempts to make auto-reinstall difficult for the next update of Windows.

.DESCRIPTION
Permanantly and forcefully removes Microsoft Edge, and attempts to make auto-reinstall difficult for the next update of Windows. Be prepared to call this script whenever Windows updates.

.LINK
- What: motive
    - Url: <https://www.youtube.com/watch?v=w8EGomuEX8s&t=140s>
    - Retrieved: 2024_02_02
.LINK
- What: howto uninstall, prevent reinstall
    - Url: <https://www.tomsguide.com/how-to/how-to-uninstall-microsoft-edge>
    - Retrieved: 2024_02_02
.LINK
- What: howto remove AppX package
    - Url: <https://www.process.st/how-to/uninstall-microsoft-edge/>
    - Retrieved: 2024_02_02
#>

# *********************
# * --- Uninstall --- *
# *********************

$app_path = "${env:ProgramFiles(x86)}\Microsoft\Edge\Application\*\Installer\setup.exe"
$app_args = "setup.exe --uninstall --system-level --verbose-logging --force-uninstall"

dir $app_path -Recurse |
foreach {
    iex "$app_path $app_args"
}

# ********************************
# * --- Discourage Reinstall --- *
# ********************************

$reg_path = "HKLM:\SOFTWARE\Microsoft\EdgeUpdate"
$reg_name = "DoNotUpdateToEdgeWithChromium"
$reg_type = 'REG_DWORD'

if (-not (Test-Path $reg_path)) {
    New-Item `
        -Path $reg_path `
        -Force
}

New-ItemProperty `
    -Path $reg_path `
    -Name $reg_name `
    -PropertyType $reg_type `
    -Value 1 `
    -Force

# *******************************
# * --- Remove AppX Package --- *
# *******************************

Get-AppXPackage `
    -Name "*MicrosoftEdge*" `
    -AllUsers |
Remove-AppXPackage `
    -Force

