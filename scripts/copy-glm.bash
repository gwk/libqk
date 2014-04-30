#!/usr/bin/env bash
# Copyright 2013 George King.
# Permission to use this file is granted in license-libqk.txt (ISC License).

# copy the glm headers.
# this script is invoked by build-lib.bash.

OS=$1; shift;
SRC_DIR=$1; shift;

INSTALL_DIR="submodules/libqk-built-$OS"
dst_dir="$INSTALL_DIR/include/glm"

echo "copying glm for $OS..."

set -e
[[ -z "$BUILD_QUIET" ]] && set -x
[[ -d "$dst_dir" ]] && rm -rf "$dst_dir"
cp -r "$SRC_DIR/glm" "$dst_dir"
rm "$dst_dir/CMakeLists.txt"

# lastly, remove carriage returns from the source.
find -X "$dst_dir" -type f | xargs -L 1 sed -i '' $'s/\r//g'
