<#
.LINK
Description: ChrisTitusTech powershell-profile
Url: <https://github.com/ChrisTitusTech/powershell-profile>
Retrieved: 2025_01_24

.LINK
Description: NerdFonts repository
Url: <https://github.com/ryanoasis/nerd-fonts>
Retrieved: 2025_01_25
#>

function Install-NerdFonts {
    param (
        [string]$FontName = "CascadiaCode",
        [string]$FontDisplayName = "CaskaydiaCove NF",
        [string]$Version = "3.2.1"
    )

    try {
        [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
        $fontFamilies = (New-Object System.Drawing.Text.InstalledFontCollection).Families.Name

        if ($fontFamilies -contains "${FontDisplayName}") {
            Write-Output "Font ${FontDisplayName} already installed"
            return
        }

        $fontZipUrl = "https://github.com/ryanoasis/nerd-fonts/releases/download/v${Version}/${FontName}.zip"
        $zipFilePath = "$env:TEMP\${FontName}.zip"
        $extractPath = "$env:TEMP\${FontName}"

        $webClient = New-Object System.Net.WebClient
        $webClient.DownloadFileAsync((New-Object System.Uri($fontZipUrl)), $zipFilePath)

        while ($webClient.IsBusy) {
            Start-Sleep -Seconds 2
        }

        Expand-Archive -Path $zipFilePath -DestinationPath $extractPath -Force
        $destination = (New-Object -ComObject Shell.Application).Namespace(0x14)

        Get-ChildItem -Path $extractPath -Recurse -Filter "*.ttf" |
        ForEach-Object {
            if (-not(Test-Path "C:\Windows\Fonts\$($_.Name)")) {
                $destination.CopyHere($_.FullName, 0x10)
            }
        }

        Remove-Item -Path $extractPath -Recurse -Force
        Remove-Item -Path $zipFilePath -Force
    }
    catch {
        Write-Error "Failed to download or install ${FontDisplayName} font. Error: $_"
    }
}
