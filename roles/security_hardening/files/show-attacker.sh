#!/bin/bash

logpath=/root/fail2ban-eval/logs

grep "|" $logpath/*.log | awk -F: '{print $2}' | sort -n | sort -u
echo "[+] Nr. of attackers: $(grep "|" $logpath/*.log | awk -F: '{print $2}' | sort -n | sort -u | wc -l)"
