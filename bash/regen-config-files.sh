#!/usr/bin/env bash
source ./common/common

# ignore the error
set -E
# exit on error
# set -e

Mode="local"
# see for first argument to match local or dev
if [ "$1" == "dev" ]; then
  Mode="dev"
elif [ "$1" == "local" ]; then
  Mode="local"
else
  # throw error
  echo "Invalid mode specified. Please use 'local' or 'dev'."
  exit 1
fi

# cd into each directory
for key in "${!Directories[@]}"; do
  echo "-------------------------"
  echo "---- Going to ${key} ----"
  cd ${Directories[$key]}

  # remove config files
  rm public/config.json
  rm public/config*.json
  cp public/app.config.json public/config.local.json
  cp public/app.config.json public/config.dev.json

  if [ $key == "mgmt" ]; then
    # http://localhost:5101
    yq -i '.api.mgmtUri = "http://localhost:5101" | .api.tenantUri = "http://localhost:5102" | .auth.authority = "http://localhost:5305"' public/config.local.json
  else
    yq -i '.api.tenantUri = "http://localhost:5102" | .api.baseUri = "http://localhost:5102" | .auth.authority = "http://localhost:5305"' public/config.local.json
  fi
  gsed -i 's/{DOMAIN_HOST}/dev.edgraph/g' public/config.dev.json

  if [ $Mode == "dev" ]; then
    cp public/config.dev.json public/config.json
  else
    cp public/config.local.json public/config.json
  fi

  # cleanup the config files
  if [ $key == "mgmt" ]; then
    yq -i 'del(.api.baseUri)' public/app.config.json
    yq -i 'del(.api.baseUri)' public/config.local.json
    yq -i 'del(.api.baseUri)' public/config.json
    yq -i 'del(.api.baseUri)' public/config.dev.json
  else
    yq -i 'del(.api.tenantUri) | del(.api.mgmtUri) | del(.auth.mgmtUri)' public/app.config.json
    yq -i 'del(.api.tenantUri) | del(.api.mgmtUri) | del(.auth.mgmtUri)' public/config.local.json
    yq -i 'del(.api.tenantUri) | del(.api.mgmtUri) | del(.auth.mgmtUri)' public/config.json
    yq -i 'del(.api.tenantUri) | del(.api.mgmtUri) | del(.auth.mgmtUri)' public/config.dev.json
  fi
  
done