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

    public static void PressReleaseWin()
    {
        keybd_event(VK_LWIN, 0, KEYEVENTF_KEYDOWN, 0);      // Press Windows
        keybd_event(VK_LWIN, 0, KEYEVENTF_KEYUP, 0);        // Release Windows
    }
}
"@

foreach ($i in (0 .. 51)) {
    [Keyboard]::PressReleaseWin()
    Start-Sleep 0.02
}

