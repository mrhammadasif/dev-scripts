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

  export EG_app__basePath=""

  # remove the line from .npmrc that contains the "_authToken" string
  sed -i '' '/:_authToken/d' .npmrc

  # nr up
done