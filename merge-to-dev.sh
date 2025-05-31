#!/usr/bin/env bash
source ./common/common

# throw on errors
set -E

if [[ -z "$1" ]]; then
  echo "Usage: $0 BRANCH_NAME"
  exit 1
fi

Branch="$1"

doBranch() {
  dir=$1
  echo "----------------------"
  echo "Going to Dir ${dir}"
  cd $dir
  
  echo "PWD: `pwd`"
  # According to new branching strategy
  # new branch will be created from main branch
  # undo changes
  # git reset --hard
  # echo "Shifting to main Branch / Updating to latest changes:"
  
  git checkout -q development
  # echo "Fetching Latest Changes from development"
  # git fetch origin development
  # git pull origin development
  
  git merge ${Branch}
  echo " "
}

# doBranch $SharedRepo
# cd $SharedRepo
# git add .
# git commit -m "UPDATE:"${Branch}

for dir in "${Directories[@]}"; do
  doBranch $dir
done