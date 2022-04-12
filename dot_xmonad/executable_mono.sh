#!/usr/bin/env bash

if pactl list modules short | grep -q remap; then
  pactl unload-module module-remap-sink
fi
SINK="$(pactl get-default-sink)"
pactl load-module module-remap-sink master="${SINK}" sink_name=mono sink_properties="device.description='Mono'" channels=2 channel_map=mono,mono
sleep 5
pactl set-default-sink mono && notify-send "Downmix to ${SINK}"
