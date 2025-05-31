#!/usr/bin/env bash
source ./common/common

# cd into each directory and touch a text file
for key in "${!Directories[@]}"; do
  cd "${Directories[$key]}"
  code src/App.vue
done