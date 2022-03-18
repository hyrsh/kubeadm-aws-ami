#!/bin/bash

if [ "$(whoami)" == "ec2-user" ]; then
  set +o history
  echo -e "\e[31;1mNo history allowed!\e[0;0m"
fi

if [ "$(whoami)" == "ansible" ]; then
  set +o history
  echo -e "\e[31;1mNo history allowed!\e[0;0m"
fi
