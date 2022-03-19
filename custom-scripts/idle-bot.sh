#!/bin/bash

#nonsense output to prevent idle disconnects (I hate that)
#it loops from 1 to 9999
#I like characters on screen so I leveraged urandom

for i in {1..9999}; do
  echo "[!] exec | $(uuidgen -rt) | [load+${i}$(tr -cd '[:alpha:]' < /dev/urandom | fold -w2 | head -n1)] | $(tr -cd '[:alnum:]' < /dev/urandom | fold -w10 | head -n1) | $(tr -cd '[:digit:]' < /dev/urandom | fold -w1 | head -n1) | offset+$(tr -cd '[:digit:]' < /dev/urandom | fold -w2 | head -n1)h | $(tr -cd '[:digit:]' < /dev/urandom | fold -w1 | head -n1) | $(tr -cd '[:alnum:]' < /dev/urandom | fold -w20 | head -n1) | $(tr -cd '[:digit:]' < /dev/urandom | fold -w10 | head -n1)"
  sleep 2
done
