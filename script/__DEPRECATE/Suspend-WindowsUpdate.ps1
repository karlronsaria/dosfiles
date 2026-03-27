#Requires -RunAsAdmin

while ($true) {
    if ((Get-Service | ? { $_.Name -like "wuauserv" }).Status -ne "Stopped") {
        get-date -Format "yyyy-MM-dd HH:mm:ss`n" # Uses DateTimeFormat
        net stop wuauserv
        "`n"
    }
}
