#!/bin/bash
filename="/etc/asterisk/sip.conf"
hostname="$1"

if [ "$2" == "silent" ]; then 
  debug=0
else
  debug=1
fi

currentip=$(grep externaddr $filename)
currentip=${currentip##*=}
if [ "$debug" == 1 ]; then echo "ip read from file $filename is: $currentip";fi

newip=$(host $hostname)
newip=${newip##* }

if [ "$debug" == 1 ]; then echo "ip from hostname $hostname is: $newip";fi

if [ "$newip" != "$currentip" ]; then
  if [ "$debug" == 1 ]; then echo "ips different";fi
  cp $filename $filename.old
  sed "s/externaddr=$currentip/externaddr=$newip/g" $filename.old > $filename
  rm -f $filename.old
  /usr/sbin/asterisk -rx "sip reload" &> /dev/null
else
  if [ "$debug" == 1 ]; then echo "no change";fi
fi
