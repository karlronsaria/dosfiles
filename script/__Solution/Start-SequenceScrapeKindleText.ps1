<#
.LINK
Url: <https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-keybd_event>
Retrieved: 2025_01_08
.LINK
Url: <https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-sendinput>
Retrieved: 2025_01_08
#>
Param(
    [ArgumentCompleter({
        Param($A, $B, $C)

        . "$(Get-ProfileLocation -Default)\Scripts\PsTool\demand\Access.ps1"

        $captions = Get-OpenWindow | foreach { $_.Caption }
        $suggests = $captions | where { $_ -like "$C*" }

        return $(if (@($suggests).Count -eq 0) {
            $captions
        }
        else {
            $suggests
        }) |
        foreach {
            "`"$_`""
        }
    })]
    [String]
    $Caption,

    [Int]
    $PageCount = -1
)

Import-DemandModule access

if (-not (Test-OpenWindow -Caption $Caption) {
    return "App window could not be found: $Caption"
}

Set-ForegroundOpenWindow -Caption $Caption
$wshell = New-Object -ComObject wscript.shell

# Load Windows Script Host COM Object
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public class Keyboard
{
    [DllImport("user32.dll", SetLastError = true)]
    public static extern void keybd_event(byte bVk, byte bScan, uint dwFlags, int dwExtraInfo);

    public const int KEYEVENTF_KEYDOWN = 0x0;
    public const int KEYEVENTF_KEYUP = 0x2;
    public const byte VK_LWIN = 0x5B;      // Left Windows Key
    public const byte VK_MENU = 0x12;      // Alt Key
    public const byte VK_SNAPSHOT = 0x2C;  // Print Screen Key

    public static void SaveScreen()
    {
        // Press keys: Win + Alt + PrtSc
        keybd_event(VK_LWIN, 0, KEYEVENTF_KEYDOWN, 0);      // Press Windows
        keybd_event(VK_MENU, 0, KEYEVENTF_KEYDOWN, 0);      // Press Alt
        keybd_event(VK_SNAPSHOT, 0, KEYEVENTF_KEYDOWN, 0);  // Press PrtSc

        // Release keys in reverse order
        keybd_event(VK_SNAPSHOT, 0, KEYEVENTF_KEYUP, 0);    // Release PrtSc
        keybd_event(VK_MENU, 0, KEYEVENTF_KEYUP, 0);        // Release Alt
        keybd_event(VK_LWIN, 0, KEYEVENTF_KEYUP, 0);        // Release Windows
    }
}
"@

sleep 1

0 .. $PageCount | foreach {
    # Call the method to simulate the key combination
    [Keyboard]::SaveScreen()
    sleep 1
    $wshell.SendKeys("{RIGHT}")
    sleep 2
}

