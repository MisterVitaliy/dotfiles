#!/bin/bash
Xorg &


#xset dpms 600 600 600
#xset +dpms
#xset s 300 300 #xset s 10800 10800 &
#xset s on
#xmodmap -e "clear lock"
#xmodmap -e 'remove Lock = Caps_Lock' -e 'keycode 66 = Escape'

#xset r rate 300 50
#xrdb -load ~/.Xresources


while true; do
	xsetroot -name "| $($HOME/.config/scripts/ram.sh) | $($HOME/.config/scripts/battery.sh) | $($HOME/.config/scripts/keyboard.sh) | $($HOME/.config/scripts/wlan.sh --info) | $(date "+DATE: %m/%d/%y TIME: %H:%M:%S") |"
	sleep 1s
done & 

powertop --auto-tune
#feh --bg-fill ~/.config/ruby.png &
hsetroot -solid "#fcfdfe" &
#pulseaudio --start &
sxhkd &
dunst &
compton &
xautolock -time 10 -locker "setxkbmap us; i3lock-fancy" -notify 60 -notifier "notify-send -u critical -t 10000 -- 'LOCKING screen in 60 seconds'"

DISPLAY=:0 exec dwm #grml-x dwm


