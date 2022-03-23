#!/bin/bash

sshd_ips=$(journalctl -u sshd | tail -500 | grep "disconnect from" | awk -F] '{print $2}' | sed -e "s/: Received disconnect from //g" -e "s/ port.*//g" | sort -n | sort -u)

atklg=/root/fail2ban-eval/logs

myip=$(w | grep ec2-user | awk '{print $3}')

echo "-----------------------------------------"
echo "My IP: $myip"
echo "If you see your IP banned, unban it with:"
echo "  - fail2ban-client set sshd unban $myip"
echo -e "\e[31;1mBEFORE\e[0;0m you reconnect with SSH!"
echo "-----------------------------------------"

for IP in $sshd_ips; do
  if [ $(grep -ch $IP $atklg/*.log | awk '{ips+=$1}END{print ips}') == 0 ]; then
    if [ "$IP" != "$myip" ]; then
      echo "Adding $IP to banlist"
      fail2ban-client set sshd banip $IP
    fi
  fi
done
