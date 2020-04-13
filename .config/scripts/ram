#!/bin/sh
ram=$(grep Mem /proc/meminfo | awk '{ printf "%.2f ", $2/1048576 }' | awk '{printf "%.2f GB/%.2f GB", ($1-$3), $3 }')
if [ -d "/sys/class/thermal/thermal_zone1" ]; then
	t_cpu=$(awk '{ printf "%.1f", $1/1000 }' /sys/class/thermal/thermal_zone1/temp)
fi
echo "$ram($t_cpu°C)"
