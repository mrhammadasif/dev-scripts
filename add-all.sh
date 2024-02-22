#!/usr/bin/env bash
source ./common/common

set -e

for dir in "${Directories[@]}"; do
  cd $dir
  git add .
done
