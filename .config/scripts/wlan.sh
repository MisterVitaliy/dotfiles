#!/bin/sh

#if [ $(id -u) -ne 0 ]; then
	#echo "This script must be run as root" 1>&2
	#error
	#exit 1
#fi


error(){
	echo ""
	echo "-i - set network interface"
	echo "-m|--mode - set wifi type (wep|wpa|wpa2|eduroam|open)"
	echo "-s|--ssid - set wifi name)"
	echo "-p|--pass - set password)"
	echo "-u|--user - set user identity (for eduroam mode)"
	echo "--scan - scan for wifi"
	echo "--info - scan info about connected wifi"
}


config="$HOME/wpa_temp.conf"
while test $# -gt 0; do
	case "$1" in
		-i|--interface)
			interface="$2"
			shift 2
			;;
		-m|--mode)
			mode="$(echo "$2" | tr '[:upper:]' '[:lower:]')"
			shift 2
			;;
		-s|--ssid)
			ssid="$2"
			shift 2
			;;
		-p|--pass)
			pass="$2"
			shift 2
			;;
		-u|--user)
			user="$2"
			shift 2
			;;
		--scan)
			iw "$interface" scan | grep SSID
			shift 1
			exit 0
			;;
		--info)
			wlan=$(iw dev wlan0 link | grep -i ssid | awk '{print $2}')
			wlan_p=$(iw dev wlan0 link | grep -E "(signal|bitrate)" | awk -F: '{print $2}' | awk '{print $1" "$2}' | tr '\n' ' ')
			echo "$wlan($wlan_p)"
			exit 0
			;;
		*)
			echo "something else"
			shift 2
			;;
	esac
done


if [ -z "${interface+x}" ]; then
	interface="wlan0"
elif ! [ -d /sys/class/net/"$interface" ]; then
	echo "Network interface \"$interface\" does not exist" 1>&2
	error
	exit 1
fi


if [ -z "${mode+x}" ]; then
	mode="wpa2"
elif ! echo "$mode" | grep -Eq "^(open|wep|wpa|wpa2|eduroam)$"; then
	echo "Mode \"$mode\" does not exist" 1>&2
	error
	exit 1
fi


if [ -z "${ssid+x}" ]; then
	echo "SSID must be set. Use --ssid flag" 1>&2
	exit 1
fi


if [ -z "${pass+x}" ] && ! [ $mode = "open" ]; then
	echo "Password must be set. Use --pass flag" 1>&2
	exit 1
fi


if [ -z "${user+x}" ] && [ $mode = "eduroam" ]; then
	echo "You use eduroam network. User identity must be set. Use --user flag" 1>&2
	exit 1
fi


printf " INTERFACE %s\\n MODE %s\\n SSID %s\\n PASS %s\\n" "$interface" "$mode" "$ssid" "$pass" | column -t -s " "













#echo "ctrl_interface=DIR=/var/run/wpa_supplicant"  > $config
##GROUP=netdev
#echo "ctrl_interface_group=wheel" >> $config
#echo "update_config=1" >> $config
#echo "ap_scan=1" >> $config
#echo -e "\n" >> $config
#echo "network={" >> $config
#echo "ssid=\"$ssid\"" >> $config
#echo "scan_ssid=1" >> $config
#
#if [[ $mode =~ (open|wep)$ ]]; then
    #echo "key_mgmt=NONE" >> $config
	#if [ "$mode" = "web" ]; then
		#echo "wep_key0=\"$pass\"" >> $config
		#echo "wep_tx_keyidx=0" >> $config
	#fi
#elif [[ $mode =~ (wpa|wpa2)$ ]]; then
	#if [ "$mode" = "wpa2" ]; then
		#echo "proto=RSN" >> $config
	#fi
    #echo "key_mgmt=WPA-PSK" >> $config
	#pass="$(wpa_passphrase $ssid $pass | grep 'psk=' | tr -d '\t')"
	#echo "$pass" >> $config
#elif [ $mode = "peap" ]; then
	#echo "auth_alg=OPEN" >> $config
	##echo "key_mgmt=IEEE8021X" >> $config
	#echo "key_mgmt=WPA-EAP" >> $config
	#echo "proto=WPA RSN" >> $config
	#echo "pairwise=CCMP TKIP" >> $config
	#echo "eap=PEAP" >> $config
	#echo "identity=\"$user\"" >> $config
	##$pass=$(echo -n "$pass" | iconv -t utf16le | openssl md4)
	#pass=$(echo -n $pass | iconv -t utf16le | openssl md4 | cut -d' ' -f2)
	#echo "password=hash:$pass" >> $config
	#echo "phase1=\"peaplabel=0\"" >> $config
	#echo "phase2=\"auth=MSCHAPV2\"" >> $config
#else
	#error
#fi
#
#echo "priority=1" >> $config
#echo "}" >> $config


















printf "ctrl_interface=DIR=/var/run/wpa_supplicant
ctrl_interface_group=wheel
update_config=1
ap_scan=1

network={
ssid=\"%s\"
scan_ssid=1
" "$ssid" > "$config"

if echo "$mode" | grep -Eq "^(open|wep)$"; then
    echo "key_mgmt=NONE" >> "$config"
	if [ "$mode" = "web" ]; then
		printf "wep_key0=\"%s\"
		wep_tx_keyidx=0" "$pass" >> "$config"
	fi
elif echo "$mode" | grep -Eq "^(wpa|wpa2)$"; then
	if [ "$mode" = "wpa2" ]; then
		echo "proto=RSN" >> "$config"
	fi
    echo "key_mgmt=WPA-PSK" >> "$config"
	pass=$(wpa_passphrase "$ssid" "$pass" | grep 'psk=' | tr -d '\t')
	echo "$pass" >> "$config"
elif [ $mode = "eduroam" ]; then
	printf "auth_alg=OPEN
key_mgmt=WPA-EAP
proto=WPA RSN
pairwise=CCMP TKIP
eap=PEAP
identity=\"%s\"
" "$user" >> "$config"
pass=$(echo "$pass" | iconv -t utf16le | openssl md4 | cut -d' ' -f2)
	printf "password=hash:%s
phase1=\"peaplabel=0\"
phase2=\"auth=MSCHAPV2\"
" "$pass" >> "$config"
else
	error
fi

printf "priority=1\\n}" >> "$config"

pgrep wpa_supplicant | xargs kill -9

ip link set $interface down
dhclient -r $interface
wpa_supplicant -Dwext -B -i "$interface" -c "$config" | grep -v "ioctl"
iw "$interface" set type managed
ip link set "$interface" up
dhclient "$interface"
rm "$config"
status=$(ping 8.8.8.8 -c 6 | grep -Eo "[0-9]+%")
printf "%s  =>  " "$status"
[ "$status" = "100%" ] && printf "FAIL" || printf "SUCCESS"
printf "\\n"



