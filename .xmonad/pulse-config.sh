#!/usr/bin/env bash

pactl load-module module-remap-sink master=alsa_output.pci-0000_00_1f.3.analog-stereo sink_name=mono sink_properties="device.description='Mono'" channels=2 channel_map=mono,mono
sleep 5
pactl set-default-sink mono
