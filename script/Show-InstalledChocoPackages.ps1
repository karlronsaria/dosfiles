$log = "C:\ProgramData\chocolatey\logs\chocolatey.log"
type $log | Select-String -Pattern "Successfully installed"
