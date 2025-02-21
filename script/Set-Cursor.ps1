
function Set-Cursor {
    function Start-CursorRefresh {
        <#
        .LINK
        - url
          - <https://superuser.com/questions/1769195/how-to-change-mouse-cursor-using-powershell-script-on-windows-11-without-restart>
          - <https://superuser.com/users/8672/harrymc>
          - <https://devblogs.microsoft.com/scripting/use-powershell-to-change-the-mouse-pointer-scheme/>
        - retrieved: 2024-09-24
        #>
        $cSharpSig =
@'
[DllImport("user32.dll", EntryPoint = "SystemParametersInfo")]
public static extern bool SystemParametersInfo(
    uint uiAction,
    uint uiParam,
    uint pvParam,
    uint fWinIni);
'@

        $cursorRefresh = Add-Type `
            -MemberDefinition $cSharpSig `
            -Name WinAPICall `
            -Namespace SystemParamInfo `
            –PassThru

        $cursorRefresh::SystemParametersInfo(0x0057, 0, $null, 0)
    }

    # Path to the registry key
    $regPath = "HKCU:\Control Panel\Cursors"
    $systemCursorPath = "C:\Windows\Cursors"

    # Specify the cursor files (replace these with your desired cursor files)
    $cursorScheme = @{
        "Arrow"        = "$systemCursorPath\aero_arrow.cur"
        "Help"         = "$systemCursorPath\aero_helpsel.cur"
        "AppStarting"  = "$systemCursorPath\aero_working.ani"
        "Wait"         = "$systemCursorPath\aero_busy.ani"
        "Crosshair"    = "$systemCursorPath\cross_i.cur"
        "IBEAM"        = "$systemCursorPath\beam_i.cur"
        "NWPen"        = "$systemCursorPath\pen_i.cur"
        "No"           = "$systemCursorPath\no.cur"
        "SizeNS"       = "$systemCursorPath\size_ns.cur"
        "SizeWE"       = "$systemCursorPath\size_we.cur"
        "SizeNWSE"     = "$systemCursorPath\size_nwse.cur"
        "SizeNESW"     = "$systemCursorPath\size_nesw.cur"
        "SizeAll"      = "$systemCursorPath\size_all.cur"
        "UpArrow"      = "$systemCursorPath\up_i.cur"
        "Hand"         = "$systemCursorPath\aero_link.cur"
    }

    # Apply the cursor scheme to the registry
    foreach ($cursor in $cursorScheme.GetEnumerator()) {
        Set-ItemProperty -Path $regPath -Name $cursor.Key -Value $cursor.Value
    }

    # Notify the system of the change
    RUNDLL32.EXE USER32.DLL,UpdatePerUserSystemParameters ,1 ,True

