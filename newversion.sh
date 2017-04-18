#!/bin/bash

echo Input version number:
read versionNumber

echo "### Creating version number: $versionNumber"

# Create branch
git checkout -b development
#git reset --hard
#git clean -fd
git checkout -b feature/"$versionNumber"
git branch

# Modify versions
agvtool bump -all
agvtool new-marketing-version $versionNumber

# Git push
git add --all
git commit -a -m \"new version $versionNumber\"
git status