# Usage

Run the numbered command files ``*.bat`` in sequence, keeping in mind certain actions that need to be taken for each one, described below.

| File | Description |
|------|-------------|
| ``00_WhereAmI.bat`` | Echoes the last command script (``00`` through ``05``) that was executed. |
| ``01_NewMyLocalUsers.bat`` | Creates the local user profiles listed in ``res/setting.json``. |
| ``02_ConnectMyWebProfile.bat`` | Connects to the local WLAN (typically WiFi) profile specified in ``res/setting.json`` and sets auto-connect. |
| ``03_InstallPackageManager.bat`` | Installs the Chocolatey package manager: <https://community.chocolatey.org>. Requires an internet connection. |
| ``04_InstallMyPackages.bat`` | Using a package manager, installs the packages listed in ``res/setting.json``. Requires an internet connection. |
| ``05_RemoveLastLoginUser.bat`` | Removes the local user profile that was used to set up the device. The profile name is saved to ``res/session.json`` when you run script ``01``. You need to be logged out of that profile before running this script. |

