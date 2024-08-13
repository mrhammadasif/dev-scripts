#!/usr/bin/env bash
source ./common/common

# echo ${*%"forme"} # it will remove forme string from the expanded string ${*}
# this will gives you the last argument
# echo ${!#}
# so using both
# ${*%${!#}}
# mean that expanded string with all the arguments, last argument (to string) will be removed from the last argument
# echo $@
for key in "${!Directories[@]}"; do
  echo "-------------------------"
  echo "---- Going to ${key} ----"
  cd ${Directories[$key]}
  echo "DIR: `pwd`"

  # Define a log file for the server's output
  LOG_FILE="${key}_server_output.log"

  # Start the Node.js server in the background and redirect stdout and stderr to the log file
  node server.mjs > $LOG_FILE 2>&1 &

  # Capture the process ID (PID) of the server
  NODE_PID=$!

  # Wait for 5 seconds
  sleep 1

  # Output the server's stdout
  echo "Node.js server output:"
  LOG_FILE_CONTENTS=$(cat $LOG_FILE)
  echo $LOG_FILE_CONTENTS
  # read the content of the file


  # get the port number from the log file, which is listed in URL format
  # PORT=$(echo $LOG_FILE_CONTENTS | sed -n 's|.*http://localhost:\([0-9]*\).*|\1|p')
  # PORT=$(echo $LOG_FILE_CONTENTS | sed -n 's|.*http://localhost:\([0-9]*[^ ]*\).*|\1|p')
  PORT=$(echo $LOG_FILE_CONTENTS | awk -F'http://localhost:' '{print $2}')

  echo "PORT: $PORT"

  # Curl and show the output of the server
  HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:$PORT/config.json)

  # echo "HC:"
  # curl http://localhost:$PORT/hc
  # echo "LIVENESS:"
  # curl http://localhost:$PORT/liveness
  echo "INDEX:"
  curl http://localhost:$PORT

  echo "HTTP_CODE: $HTTP_CODE"

  # Stop the Node.js server
  kill $NODE_PID

  rm $LOG_FILE

  echo "Node.js server stopped after 5 seconds."
done