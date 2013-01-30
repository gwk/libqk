#!/usr/bin/env bash
# Copyright 2013 George King.
# Permission to use this file is granted in libqk/license.txt.

# build command line tools.


set -e

error() { echo 'error:' "$@" 1>&2; exit 1; }

[[ $0 == "./build-targets.sh" ]] || error "must invoke as ./build-targets.sh"

xcodebuild -project qk-mac.xcodeproj/ -target jnb-image-with-png -configuration Release install

