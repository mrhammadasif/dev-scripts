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

  nr refresh-token
  # copy the last line from /Users/hammadasif/projects/edwire/mongo8/.npmrc to .npmrc
  fileContents=$(tail -n 5 ~/.npmrc)
  # append to .npmrc
  echo "${fileContents}" >> .npmrc

  docker build -t ${key} -f ./Dockerfile ..
  PORT=$(cat public/app.config.json | jq -r '.auth.redirectUri' | sed 's/.*:\([0-9]*\).*/\1/')
  docker run -d --name ${key} -p ${PORT}:${PORT} ${key} -e EG_app__basePath=""

  # Then remove the line containing :_authToken from .npmrc
  sed -i '' '/:_authToken/d' .npmrc

done