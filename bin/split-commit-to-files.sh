#! /usr/bin/env bash

# Reverts HEAD, then re-applies it one file at at time.

cd $(git rev-parse --show-toplevel)
set -e
git diff --quiet HEAD

echo Breaking apart this commit:
git log -1 --oneline --no-decorate

FILES=$(git show --name-only --no-decorate --foramt='' HEAD)
MESSAGE=$(git log --oneline --no-decorate -1)
BASE_HASH=$(git log -1 --format=%H)

git revert --no-edit HEAD

for FILE in $FILES
do
  git checkout $BASE_HASH -- $FILE
  git commit -m "$MESSAGE : $FILE"
done
