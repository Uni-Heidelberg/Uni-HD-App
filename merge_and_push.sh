#!/bin/bash
git checkout develop
git merge Mensa
git merge News
git merge Maps
git merge Settings
git push
git checkout Mensa
git merge develop
git push
git checkout News
git merge develop
git push
git checkout Maps
git merge develop
git push
git checkout Settings
git merge develop
git push
git checkout develop