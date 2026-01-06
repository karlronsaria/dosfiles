# issue

- [ ] 2025-04-01-171322
  - where: ``Rename-DateTimeString``
  - howto

    ```text
    C:\dev\pwsh\__OLD  ls
    
        Directory: C:\dev\pwsh\__OLD
    
    Mode                 LastWriteTime         Length Name
    ----                 -------------         ------ ----
    d----           1/12/2025  2:28 AM                2023_06_07_184742
    d----           9/16/2023  6:06 AM                2023_09_16_060605
    d----          12/10/2023 11:21 PM                2023_12_10_232146
    d----          12/14/2023  9:00 PM                2023_12_14_205901
    d----          12/20/2023  9:26 PM                2023_12_20
    d----           1/23/2024 10:26 PM                2024_01_23
    d----           10/4/2024  2:28 AM                2024_10_04_022847
    d----           10/5/2024  7:56 PM                2024_10_05_195617
    d----           1/12/2025  9:51 PM                2025_01_12_004845
    d----           1/26/2025 12:47 AM                2025_01_26_004732
    d----            2/2/2025 10:46 PM                2025_02_02_224603
    d----            3/8/2025  6:20 PM                2025-03-08-182043
     
    C:\dev\pwsh\__OLD  mkdir $(gdt)
    
        Directory: C:\dev\pwsh\__OLD
    
    Mode                 LastWriteTime         Length Name
    ----                 -------------         ------ ----
    d----            4/1/2025  5:10 PM                2025-04-01-171048

    C:\dev\pwsh\__OLD  dir * | Rename-DateTimeString -Force
    ```

  - actual

    ```text
    Success LineCountsMatch CharCountsMatch DiffCountsMatch
    ------- --------------- --------------- ---------------
      False            True           False           False
    Rename-DateTimeString: Something went wrong.
    
    C:\dev\pwsh\__OLD  ls
    
        Directory: C:\dev\pwsh\__OLD
    
    Mode                 LastWriteTime         Length Name
    ----                 -------------         ------ ----
    d----           1/12/2025  2:28 AM                2023-06-07-184742
    d----           9/16/2023  6:06 AM                2023-09-16-060605
    d----          12/10/2023 11:21 PM                2023-12-10-232146
    d----          12/14/2023  9:00 PM                2023-12-14-205901
    d----          12/20/2023  9:26 PM                2023-12-20
    d----           1/23/2024 10:26 PM                2024-01-23
    d----           10/4/2024  2:28 AM                2024-10-04-022847
    d----           10/5/2024  7:56 PM                2024-10-05-195617
    d----           1/12/2025  9:51 PM                2025-01-12-004845
    d----           1/26/2025 12:47 AM                2025-01-26-004732
    d----            2/2/2025 10:46 PM                2025-02-02-224603
    d----            3/8/2025  6:20 PM                2025-03-08-182043
    d----            4/1/2025  5:10 PM                2025-04-01-171048
    ```

- [ ] issue 2025-02-21-012921
  - actual
    - nvim commands ``PutDate`` and ``PutDateTime`` use old format
  - note
    - You need to look for other system time query tools
      - lua: ``%Y-%m-%d-%H%M%S``

- [ ] issue 2025-02-21-012807
  - actual
    - ``Replace`` output does not include file names

---

[← Go Back](../readme.md)

