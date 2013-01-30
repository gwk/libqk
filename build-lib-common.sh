#!/usr/bin/env bash
# Copyright 2013 George King.
# Permission to use this file is granted in libqk/license.txt.

# build a static lib from autoconf/make based source.
# this script is sourced by the platform-specific scripts.

set -e

error() { echo 'error:' "$@" 1>&2; exit 1; }

[[ $0 =~ \./build-lib-.*\.sh ]] || error "must invoke as ./build-lib-*.sh (not $0)"

echo
echo "build-lib-common.sh: $@"

lib_name="$1"; shift
src_dir="$1"; shift
install_dir="$PWD/$1"; shift
config_args="$@"
qk_root="$PWD"
build_dir="build/$lib_name"

echo "lib_name: $lib_name; src_dir: $src_dir; install_dir: $install_dir"
echo "config_args: $config_args"
echo "qk_root: $qk_root"
echo "build_dir: $build_dir"

rm -rf "$install_dir"
