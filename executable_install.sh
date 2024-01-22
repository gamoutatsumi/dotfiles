#!/bin/sh
GITHUB_USERNAME=gamoutatsumi
go run github.com/twpayne/chezmoi@latest init --apply $GITHUB_USERNAME
go run github.com/aquaproj/aqua-installer@latest
