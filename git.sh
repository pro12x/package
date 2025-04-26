#!/bin/bash

git init

#=======================Clean Project
flutter clean
flutter pub get
#====================================

git add .
git commit -m "Package Completed on $(date)"
git branch -M main
git remote add github https://github.com/pro12x/package.git
git remote add gitea https://learn.zone01dakar.sn/git/fmokomba/package.git
git push -u github main
git push -u gitea main

