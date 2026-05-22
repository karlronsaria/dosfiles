function Save-UnityGitBundle {
    $src_path = $PsScriptRoot
    $src = Join-Path $src_path "../res/unity.gitignore"
    $dst = Get-Location | Join-Path ".gitignore"
    Copy-Item $src $dst -ErrorAction SilentlyContinue
    git init
    git add .
    git commit -m "first commit"
    $dst_path = Join-Path $src_path "backup"
    mkdir $dst_path | Out-Null

    # Uses DateTimeFormat
    $datetime = Get-Date -Format "yyyy-MM-dd-HHmmss"
    $dst = "$($dst_path | Join-Path (Get-Location | Split-Path -Leaf))_$($datetime).bundle"
    git bundle create $dst --all
}

