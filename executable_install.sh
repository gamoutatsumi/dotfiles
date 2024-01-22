#!/bin/sh
REPO_NAME="https://github.com/gamoutatsumi/dotfiles.git"
go run github.com/twpayne/chezmoi@latest init --apply $REPO_NAME
go run github.com/aquaproj/aqua-installer@latest
