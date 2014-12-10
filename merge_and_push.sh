#!/bin/bash

branches=("Mensa" "News" "Maps" "Settings")

for branch in "${branches[@]}"; do
	git checkout $branch
	git pull --rebase
done

git checkout develop

for branch in "${branches[@]}"; do
	git merge $branch
done

git push

for branch in "${branches[@]}"; do
	git checkout $branch
	git merge develop
	git push
done

git checkout develop