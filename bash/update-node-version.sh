#!/usr/bin/env bash
source ./common/common

# ignore the error
set -E
# exit on error
# set -e

# cd into each directory
for key in "${!Directories[@]}"; do
  echo "-------------------------"
  echo "---- Going to ${key} ----"
  cd ${Directories[$key]}
  
  echo "22" > .nvmrc
  git add .nvmrc
  git commit -m "#12048 feat: set node version to 22"
  nvm use 22
  rm -rf node_modules
  nr refresh-token
  ni --force
  npx taze major -w
  ni
  git add package.json pnpm-lock.yaml
  git commit -m "#12048 feat: update dependencies to latest major versions"
  nr build:prod
  nr lint --fix --quiet
  git add .
  git commit -m "#12048 feat: run lint and fix issues"

  # nr up
done