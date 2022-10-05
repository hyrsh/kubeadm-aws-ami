#!/bin/bash

tmpl=sec-tmpl.yml

hlp="false"

if [ "$1" == "" ]; then
  echo -e "\e[31;1mNo secret namespace given!\e[0;0m"
  hlp="true"
fi
if [ "$2" == "" ]; then
  echo -e "\e[31;1mNo account name given!\e[0;0m"
  hlp="true"
fi

if [ "$hlp" == "true" ]; then
  echo "Usage:"
  echo "------"
  echo "./create-api-secret.sh <namespace> <service account name>"
  echo ""
  echo "Creates a service account token for the given account in the respective namespace."
  exit 1
fi

secname="service-account-token-$2"

cat $tmpl | sed -e "s/API_SEC_NAMESPACE/$1/g" -e "s/API_SEC_NAME/$secname/g" -e "s/API_SEC_SA/$2/g" | kubectl create -f -
