let src_path = $env.CURRENT_FILE | path dirname
let src = $src_path | path join "res/unity.gitignore"
cp -u $src (pwd | path join ".gitignore")
git init
git add .
git commit -m "first commit"

let dst_path = $src_path | path join "backup"
mkdir $dst_path

# Uses DateTimeFormat
let dt = date now | format date "%Y-%m-%d-%H%M%S"
let dst = $dst_path | path join ((pwd | path basename) + "_" + $dt + ".bundle")
git bundle create $dst --all

