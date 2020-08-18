#!/bin/bash

#creating mac address changer and ip changer
#changing mac address wont work in eth0 in virtual box for that you must connect wifi adapter 
#for mac changer you must be on real device or use a wifi adapter connector in virtual box

choice=$1

#echo "$choice"

#macchanger
if [ choice != eth0 ];then
	ip link set "$choice" down
	macchanger -a "$choice" > /dev/null
	ip link set "$choice" up
fi

#ip address changer

current_ip=$( ip addr show "$choice" | grep inet -w -m 1 | awk -F" " {' print$2 '})
echo "$current_ip"
gateway_ip=$( echo "$current_ip" | awk -F"." {' print$1"."$2"."$3".1" '})
echo "$gateway_ip"
network_id=$( echo "$gateway_ip" | awk -F"." {' print$1"."$2"."$3"." '})
echo "$network_id"

#Random number generation
octet=$((($RANDOM % 252) + 2 ))
echo "$octet"
new_ip="$network_id$octet"'/24'
echo "$new_ip"

#changing IP ADDRESS
ip addr del "$current_ip" dev "$choice"
ip addr add "$new_ip" dev "$choice"
ip route add default via "$gateway_id"

#SHOW RESULTS
echo "NEW MAC: $(ip link show $choice | grep link | awk -F" " '{ print$2 }') "
echo "NEW IP: $( ip addr show $choice | grep inet -w -m 1 | awk -F" " '{ print$2 }')"























	
