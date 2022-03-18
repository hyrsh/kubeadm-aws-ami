#!/bin/bash

f2b=/var/log/fail2ban.log

rt=/root/fail2ban-eval
lgp=$rt/logs
lg=$lgp/0_current.log

rotatelim=1000

#tail is used to get only the latest entries, NEVER exceed 150/min or the API will ban us
#more than 40 per request is not possible
tailcnt=40

for IP in $(cat $f2b | grep "NOTICE" | grep -vE "Unban|Flush|Restore" | awk '{print $NF}' | tail -$tailcnt); do
   raw=$(curl -s http://ip-api.com/json/$IP)
   b=$(echo $raw)
   #echo "ENTRY: $b"

   ip=$(echo -e $b | awk -F: '{print $15}' | awk -F, '{print $1}')
   cc=$(echo -e $b | awk -F: '{print $4}' | awk -F, '{print $1}')
   asn=$(echo -e $b | awk -F: '{print $14}' | awk -F, '{print $1}')
   cty=$(echo -e $b | awk -F: '{print $7}' | awk -F, '{print $1}')
   rgn=$(echo -e $b | awk -F: '{print $6}' | awk -F, '{print $1}')
   org=$(echo -e $b | awk -F: '{print $13}' | awk -F, '{print $1}')

   #echo -e "$cc\t| $rgn | $cty | $ip ($asn, $org)" | sed -e "s@\"@@g" -e "s@}@@g"
   echo -e "$ip\t| $cc\t| $cty\t| $rgn\t| $asn, $org" | sed -e "s@\"@@g" -e "s@}@@g" >> $lg

   if [ $(wc -l $lg | awk '{print $1}') -gt $rotatelim ]; then
     time=$(date +%Y%m%d_%H-%M-%S)
     cat $lg | sort -n | sort -u > $lgp/archive_${time}_short.log
     #mv $lg $lgp/archive_${time}.log
     rm -rf $lg
     touch $lg
   fi
   

done

#echo "Sent data to $lg"

#example output for field count

#1  {"status":
#2  "success","country":
#3  "United Kingdom","countryCode":
#4  "GB","region":
#5  "WLS","regionName":
#6  "Wales","city":
#7  "Cardiff","zip":
#8  "CF11","lat":
#9  51.481785,"lon":
#10 -3.178065,"timezone":
#11 "Europe/London","isp":
#12 "Microsoft Corporation","org":
#13 "Microsoft Azure Cloud (ukwest)","as":
#14 "AS8075 Microsoft Corporation","query":
#15 "51.137.185.163"}
