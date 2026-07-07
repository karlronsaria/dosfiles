#!/usr/bin/env bash

src_path=$(dirname "${BASH_SOURCE[0]}")
src="$src_path/res/unity.gitignore"
cp -u $src "$(pwd)/.gitignore"
git init
git add .
git commit -m "first commit"

dst_path="$src_path/backup"
mkdir $dst_path

# Uses DateTimeFormat
dt=$(date '+%Y-%m-%d-%H%M%S')
dst="$dst_path/$(basename "$(pwd)")_$dt.bundle"
git bundle create $dst --all

