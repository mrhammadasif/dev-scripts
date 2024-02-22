#!/usr/bin/env bash
source ./common/common

if [[ -z "$1" ]]; then
  echo "Usage: $0 COMMIT_MESSAGE"
  exit 1
fi

for dir in "${Directories[@]}"; do
  echo "Commiting for: $dir"
  cd $dir
  git commit -m "$1"
done
