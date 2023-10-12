#Requires -RunAsAdmin

while (1) {
    if ((Get-Service | ? { $_.Name -like "wuauserv" }).Status -ne "Stopped") {
        get-date -Format "yyyy_MM_dd HH:mm:ss`n"
        net stop wuauserv
		"`n"
    }
}
