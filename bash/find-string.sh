#!/usr/bin/env bash
source ./common/common

set -e

if [[ -z "$1" ]]; then
  echo "Usage: $0 BRANCH_NAME"
  exit 1
fi

# echo ${*%"forme"} # it will remove forme string from the expanded string ${*}
# this will gives you the last argument
# echo ${!#}
# so using both
# ${*%${!#}}
# mean that expanded string with all the arguments, last argument (to string) will be removed from the last argument
# echo $@
for dir in "${Directories[@]}"; do
  echo " "
  echo "----------------------"
  cd $dir
  echo "DIR: `pwd`"
  echo "----------------------"
  echo "finding string: $1"
  # find string in all files in the directory recursively
  # grep --exclude-dir={node_modules,dist,www} -Rin -e $1 .
  echo "$(pwd)/$(rg --color=always --line-number --ignore-case --with-filename --hyperlink-format="file://{path}" $1)"
done