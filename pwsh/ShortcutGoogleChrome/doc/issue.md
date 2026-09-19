# issue

- [ ] issue 2026-09-11-172627
  - howto

    ```powershell
    Get-ShortcutGoogleChromeLink
    ```

  - actual

    ```text
    Invoke-RestMethod: C:\shortcut\dos\pwsh\ShortcutGoogleChrome\script\ShortcutGoogleChrome.ps1:150
    Line |
     150 |      $response = Invoke-RestMethod `
         |                  ~~~~~~~~~~~~~~~~~~~
         | No connection could be made because the target machine actively refused it.
    ```

- [ ] issue 2023-09-04-005658
  - howto
    - ``../gchrome.bat``
  - actual

    ```text
    C:\Users\karlr> get-process | ? Name -like *chrome*
    C:\Users\karlr>
    ```

[← Go Back](../readme.md)
