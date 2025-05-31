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

# check if arg 2 present
if [ -z "$2" ]; then
  workItem=""
else
  workItem="$2"
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
    pnpm add "@edgraph/shared@next" --force
  else
    pnpm add "@edgraph/shared@$version" --force
  fi
  # git add .
  git add package.json
  git add pnpm-lock.yaml
  git commit -m "Update shared library to $version. fix: #$workItem"
done