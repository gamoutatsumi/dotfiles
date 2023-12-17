#!/usr/bin/env bash

killall -q polybar
while pgrep -u $UID -x polybar > /dev/null; do sleep 0.1; done

i=0
while true; do
  if [[ $i -eq 10 ]]; then
    break
  fi
  export DEFAULT_INTERFACE=$(ip route | grep '^default' | awk '{print $5}' | head -n1)
  if [[ -n $DEFAULT_INTERFACE ]]; then
    break
  fi
  let "i++"
  sleep 1
done
IFS=$'\n'
for m in $(polybar --list-monitors); do
  echo $m
  export MONITOR=$(echo $m | cut -d":" -f1)
  if grep -q primary <(echo $m); then
    nohup polybar --reload main >/dev/null 2>&1 &
  else
    nohup polybar --reload sub >/dev/null 2>&1 &
  fi
done
