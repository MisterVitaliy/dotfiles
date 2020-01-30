#!/bin/sh
screen=$(xrandr | grep " connected" | cut -f1 -d" ")
bright=$(xrandr --verbose -q | grep -A 5 "$screen" | grep -i brightness | awk '{print $2}')
if [ "$1" = "inc" ]; then
	res=$(echo "scale=2; var=($bright+($2/100));var" | bc)
elif [ "$1" = "dec" ]; then
	res=$(echo "scale=2; var=($bright-($2/100));var" | bc)
else
	bright=$(echo "$bright*100" | bc)
	echo "$bright%"
	exit 0
fi
res=$(echo "if($res<1) print 0; if($res>1.0) 1.0 else if($res>0) $res" | bc)
xrandr --output "$screen" --brightness "$res"
notify-send ":BRIGHTNESS:" "$res"