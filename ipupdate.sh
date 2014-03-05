#!/bin/bash

filestodo=()
hostname="$1"

if [ -z "$1" ] || [ "$1" == "silent" ]
then
  echo "fatal error: ARG 1 must be the hostname to lookup, the silent keyword can only be ARG 2"
  exit 1
fi

if [ $(ls /etc/asterisk | egrep "^sip.conf$") ]
then
 filestodo+=("sip.conf")
fi

if [ $(ls /etc/asterisk | egrep "^pjsip.conf$") ]
then
 filestodo+=("pjsip.conf")
fi

if [ -z "$filestodo[0]" ]
then
  echo "fatal error: neither sip.conf or pjsip.conf found, nothing to compare"
  exit 1
fi

if [ "$2" == "silent" ] 
then 
  debug=0
else
  debug=1
fi

newip=$(host -t A $hostname)
newip=${newip##* }
if [ "$debug" == 1 ]; then echo "ip from hostname $hostname is: $newip";fi

for thisfile in ${filestodo[@]}
do
  filename="/etc/asterisk/$thisfile"
  if [[ $thisfile == *pjsip* ]] 
  then 
    currentip=$(grep external_signaling_address $filename)
  else
    currentip=$(grep externaddr $filename)
  fi

  currentip=${currentip##*=}
  if [ "$debug" == 1 ]; then echo "ip read from file $filename is: $currentip";fi

  if [ "$newip" != "$currentip" ] 
  then
    if [ "$debug" == 1 ]; then echo "ips different";fi
    cp $filename $filename.old
    sed "s/$currentip/$newip/g" $filename.old > $filename
    rm -f $filename.old
    /usr/sbin/asterisk -rx "sip reload" &> /dev/null
  else
    if [ "$debug" == 1 ]; then echo "no change";fi
  fi
done
exit 0
