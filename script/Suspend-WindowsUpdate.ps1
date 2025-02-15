#Requires -RunAsAdmin

while ($true) {
    if ((Get-Service | ? { $_.Name -like "wuauserv" }).Status -ne "Stopped") {
        get-date -Format "yyyy_MM_dd HH:mm:ss`n" # Uses DateTimeFormat
        net stop wuauserv
        "`n"
    }
}
