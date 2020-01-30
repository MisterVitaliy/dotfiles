#!/bin/sh

out=''
percentage=''
line=''

if [ -d "/sys/class/power_supply/BAT0" ]; then
	percentage=$(cat /sys/class/power_supply/BAT0/energy_full /sys/class/power_supply/BAT0/energy_now | tr "\\n" " " | awk '{printf "%.2f", $2/$1*100}')
elif [ -d "/sys/class/power_supply/battery" ]; then
	if [ -f "/sys/class/power_supply/battery/capacity" ]; then
		percentage=$(cat /sys/class/power_supply/battery/capacity)
	else
		percentage=$(cat /sys/class/power_supply/battery/energy_full /sys/class/power_supply/battery/energy_now | tr "\\n" " " | awk '{printf "%.2f", $2/$1*100}')
	fi
elif [ -d "/sys/class/power_supply/BAT" ]; then
	percentage=$(cat /sys/class/power_supply/BAT/energy_full /sys/class/power_supply/BAT/energy_now | tr "\\n" " " | awk '{printf "%.2f", $2/$1*100}')
fi


if [ -d "/sys/class/power_supply/AC0" ]; then
	line=$(cat /sys/class/power_supply/AC0/online)
elif [ -d "/sys/class/power_supply/AC" ]; then
	line=$(cat /sys/class/power_supply/AC/online)
elif [ -d "/sys/class/power_supply/ac" ]; then
	line=$(cat /sys/class/power_supply/ac/online)
fi


[ "$line" -eq 1 ] && out='+'
out="$out$percentage%"


if [ -d "/sys/class/thermal/thermal_zone0" ]; then
	t_bat=$(awk '{ printf "%.1f", $1/1000 }' /sys/class/thermal/thermal_zone0/temp)
fi

echo "$out($t_bat°C)"