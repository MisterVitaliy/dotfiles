#!/bin/sh
uptime=$(awk '{ printf "%dd:%dh:%dm:%ds", ($1/86400), ($1%86400/3600), ($1%3600/60), ($1%60) }' /proc/uptime)
echo "$uptime"
