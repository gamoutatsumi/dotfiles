#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Ubuntu
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🤖
# @raycast.packageName Multipass

# Documentation:
# @raycast.description Launch Ubuntu in multipass shell
# @raycast.author Tatsumi Gamou
# @raycast.authorURL https://github.com/gamoutatsumi

alacritty -e multipass shell dev
