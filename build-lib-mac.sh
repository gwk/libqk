#!/usr/bin/env bash
# Copyright 2013 George King.
# Permission to use this file is granted in libqk/license.txt.

source ./build-lib-common.sh

export PLATFORM_TOOL_DIR=$DEV_DIR/usr/bin

lipo=lipo

"$QK_DIR/build-lib-arch.sh" MacOSX10.8 x86_64-apple-darwin x86_64 cpu_unknown

echo
echo "creating fat lib: $INSTALL_DIR"
mkdir -p "$INSTALL_DIR/lib"

cp -RP "$BUILD_DIR/x86_64/install/include" "$INSTALL_DIR/include"

# lipo is not necessary with only one arch, but this is how to do it.
$lipo \
-arch x86_64 "$BUILD_DIR/x86_64/install/lib/$LIB_NAME.a" \
-create -output "$INSTALL_DIR/lib/$LIB_NAME.a"
