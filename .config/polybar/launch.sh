#!/usr/bin/env bash

killall -q polybar
while pgrep -u $UID -x polybar > /dev/null; do sleep 0.1; done

tray_output=$(xrandr --query | grep "primary" | cut -d" " -f1)

i=0
while true; do
  if [[ $i -eq 50 ]]; then
    break
  fi
  export DEFAULT_INTERFACE=$(ip route | grep '^default' | awk '{print $5}' | head -n1)
  if [[ -n $DEFAULT_INTERFACE ]]; then
    break
  fi
  let "i++"
  sleep 1
done
for m in $(polybar --list-monitors | cut -d":" -f1); do
  export MONITOR=$m
  export TRAY_POSITION=none
  if [[ $m == "$tray_output" ]]; then
    TRAY_POSITION=right
  fi
  if [[ -z $tray_output ]]; then
    TRAY_POSITION=right
  fi
  polybar --reload main &
done
