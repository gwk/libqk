#!/usr/bin/env bash
# Copyright 2013 George King.
# Permission to use this file is granted in libqk/license.txt.

# build a static lib from autoconf/make based source.
# this script is sourced by the platform-specific scripts.

set -e

error() { echo 'error:' "$@" 1>&2; exit 1; }

[[ $0 =~ \./build-lib-.*\.sh ]] || error "must invoke as ./build-lib-*.sh (not $0)"

lib_name="$1"; shift
lib_path="$1"; shift
dst_path="$PWD/$1"; shift
config_args="$@"

qk_root="$PWD"

echo
echo "build-lib-common.sh: $lib_name $lib_path $dst_path $config_args"

cd "$lib_path"
