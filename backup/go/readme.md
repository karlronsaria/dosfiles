# howto: go package.json

## export or record current packages

```powershell
cd ~\go\pkg\mod

[pscustomobject]@{
  Retrieved = Get-Date
  Packages =
    dir go.mod -Recurse | foreach {
      $path = Split-Path $_.FullName -Parent
      $path = $path.Replace("$(Get-Location)\", "")
      $pathSplit = $path.Split("\")
      $domainSplit = $pathSplit[0].Split(".")
      $domain = "$($domainSplit[1]).$($domainSplit[0])"
      $id = "$domain.$($pathSplit[2 .. ($pathSplit.Count - 1)].Replace("\", "."))"
      $id
    }
} | ConvertTo-Json
```

## import or install from file

- [ ] todo

---

[← Go Back](../../readme.md)

