#!/bin/sh

# pulseaudio -D &
dunst &
compton &
sxhkd &
nm-applet &
# volumeicon &
# feh --bg-scale ~/.config/wall.* &
betterlockscreen -u ~/.config/wall.*
betterlockscreen -w
xautolock -time 10 -locker "betterlockscreen -l dimblur" -corners 0--- &

SYSSESSIONDIR=/etc/X11/Xsession.d
SESSIONFILES=$(run-parts --list $SYSSESSIONDIR)
if [ -n "$SESSIONFILES" ]; then
  set +e
  for SESSIONFILE in $SESSIONFILES; do
    . $SESSIONFILE
  done
  set -e
fi

while true; do
   xsetroot -name " | $(keyboard) | $(bright) | $(volume) | $(ram) | $(battery) | $( date +"%F %R" ) | "
   sleep 3m
done &

exec dwm
