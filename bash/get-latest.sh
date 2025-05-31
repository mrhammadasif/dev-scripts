#!/usr/bin/env bash
source ./common/common

set -e

for dir in "${Directories[@]}"; do
  cd $dir
  git checkout -q development
  git fetch origin development
  git merge origin/development
  git checkout -q main
  git fetch origin main
  git merge origin/main
done
