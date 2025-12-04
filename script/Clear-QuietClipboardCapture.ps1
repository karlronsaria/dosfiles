<#
.LINK
- What: Windows 11 is Hiding Your Personal Data in THIS Folder
- Url: <https://www.youtube.com/watch?v=x8GA1GnEl3o>
- Retrieved: 2025-11-06
#>

Get-ChildItem `
    -Path "$env:LOCALAPPDATA\Packages" `
    -Recurse `
    -Include *.dat, *ScreenClip `
    -ErrorAction SilentlyContinue |
Remove-Item `
    -Force `
    -ErrorAction SilentlyContinue

