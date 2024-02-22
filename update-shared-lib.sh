#!/usr/bin/env bash
source ./common/common

# check if arg 1 present
if [ -z "$1" ]; then
  version="latest"
elif [ "$1" == "next" ]; then
  version="next"
else
  version="$1"
fi


# cd into each directory and touch a text file
# for key in "${!DirectoriesDebug[@]}"; do
for key in "${!Directories[@]}"; do
  cd "${Directories[$key]}"
  echo "Refreshing Token: $key"
  pnpm run refresh-token
  echo "Updating: $key to the $version"
  # check if version is next
  if [ "$version" == "next" ]; then
    pnpm add "@edgraph/shared@next"
  else
    pnpm add "@edgraph/shared@$version"
  fi
  # git add .
  git add package.json
  git add pnpm-lock.yaml
  git commit -m "update(shared-lib): #8098 update the shared library to ver:$version"
done