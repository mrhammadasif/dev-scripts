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

  nr dev &
  #  capture the process ID
  pid=$!
  echo "---- Process ID: $pid ----"
  echo "---- Press any key to stop the server ----"
  read -n 1 -s
  echo "---- Stopping the server ----"
  # # force kill the process
  kill $pid 2>/dev/null
  echo "---- Server stopped ----"
  echo "-------------------------"
  
done