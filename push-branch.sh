#!/usr/bin/env bash
source ./common/common

if [[ -z "$1" ]]; then
  echo "Usage: $0 BRANCH_NAME"
  exit 1
fi

for dir in "${Directories[@]}"; do
  cd $dir
  git checkout -q $1
  git push origin $1
done