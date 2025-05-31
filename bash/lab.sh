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

  # docker build -t ${key} -f ./Dockerfile ..
  PORT=$(cat public/app.config.json | jq -r '.auth.redirectUri' | sed 's/.*:\([0-9]*\).*/\1/')
  docker stop ${key} 2>/dev/null || true
  docker rm ${key} 2>/dev/null || true
  docker run -d --name ${key} -e EG_app__basePath="" -p ${PORT}:${PORT} ${key}

  # Then remove the line containing :_authToken from .npmrc
  sed -i '' '/:_authToken/d' .npmrc
  
done