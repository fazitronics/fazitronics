#!/bin/sh

if [[ $(git status -s) ]]
then
    echo "The working directory is dirty. Please commit any pending changes."
    exit 1;
fi

# Commit to master
git push origin master

# Commit changes.
msg="rebuilding site `date`"
if [ $# -eq 1 ]
  then msg="$1"
fi

echo "Deleting old publication"
rm -rf public
mkdir public
git worktree prune
rm -rf .git/worktrees/public/

echo "Checking out gh-pages branch into public"
git worktree add -B gh-pages public origin/gh-pages

echo "Removing existing files"
rm -rf public/*
cp CNAME public/

echo "Generating site"
hugo

echo "Updating gh-pages branch"
cd public && git add --all && git commit -m "$msg"

# Push source and build repos.
git push origin gh-pages

git worktree remove public

# Come Back up to the Project Root
cd ..
