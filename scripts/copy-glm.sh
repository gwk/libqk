#!/usr/bin/env bash
# Copyright 2013 George King.
# Permission to use this file is granted in libqk/license.txt.

# copy the glm headers.
# this script is invoked by build-lib.sh.

set -e
echo "$0 $@"
error() { echo 'error:' "$@" 1>&2; exit 1; }

OS=$1; shift
SRC_DIR=$1; shift

INSTALL_DIR="submodules/libqk-built-$OS"
dst_dir=$INSTALL_DIR/include/glm

[[ -z "$BUILD_QUIET" ]] && set -x

echo "copying files..."
rm -rf "$dst_dir"
cp -r "$SRC_DIR/glm" "$dst_dir"
rm "$dst_dir/CMakeLists.txt"
