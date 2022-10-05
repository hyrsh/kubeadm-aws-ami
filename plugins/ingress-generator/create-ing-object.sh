#!/bin/bash

hlp="false"

if [ "$1" == "" ]; then
  echo -e "\e[31;1mNo ingress object namespace given!\e[0;0m"
  hlp="true"
fi
if [ "$2" == "" ]; then
  echo -e "\e[31;1mNo ingress object URL given!\e[0;0m"
  hlp="true"
fi
if [ "$3" == "" ]; then
  echo -e "\e[31;1mNo ingress object service!\e[0;0m"
  hlp="true"
fi
if [ "$4" == "" ]; then
  echo -e "\e[31;1mNo ingress object service port!\e[0;0m"
  hlp="true"
fi

if [ "$hlp" == "true" ]; then
  echo "Usage:"
  echo "------"
  echo "./create-ing-object.sh <namespace> <url> <svc> <port>"
  echo ""
  echo "Creates an ingress object with given data."
  exit 1
fi

ingns=$1
ingname=$(echo "${ingns}-$2-$4" | sed "s/\./-/g")
ingurl=$2
ingsvc=$3
ingport=$4


kubectl -n ${ingns} create ing ${ingname} --rule="${ingurl}/*=${ingsvc}:${ingport}"
