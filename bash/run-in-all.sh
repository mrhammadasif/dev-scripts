#!/usr/bin/env bash
source ./common/common

# echo ${*%"forme"} # it will remove forme string from the expanded string ${*}
# this will gives you the last argument
# echo ${!#}
# so using both
# ${*%${!#}}
# mean that expanded string with all the arguments, last argument (to string) will be removed from the last argument
# echo $@
for dir in "${Directories[@]}"; do
  echo "----------------------"
  cd $dir
  echo "DIR: `pwd`"
  str="$*"
  echo "running command: ${str}"
  ${str[@]}
done
# echo ${array[@]}
# echo ${@:1}