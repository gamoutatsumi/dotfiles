#!/bin/sh
REPO_NAME="gamoutatsumi/dotfiles"
go run github.com/twpayne/chezmoi@latest init --apply $REPO_NAME
go run github.com/aquaproj/aqua-installer@latest
