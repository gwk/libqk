#!/usr/bin/env bash
# Copyright 2013 George King.
# Permission to use this file is granted in libqk/license.txt.

source ./build-lib-common.sh

# compilers for simulator are in iPhoneOS, not iPhoneSimulator, so this is necessary.
export PLATFORM_TOOL_DIR=$DEV_DIR/Platforms/iPhoneOS.platform/Developer/usr/bin

lipo=$PLATFORM_TOOL_DIR/lipo
[[ -f $lipo ]] || error "missing lipo: $lipo"

"$QK_DIR/build-lib-arch.sh" iPhoneOS6.1        arm-apple-darwin10  armv7   cortex-a8
"$QK_DIR/build-lib-arch.sh" iPhoneOS6.1        arm-apple-darwin10  armv7s  swift
"$QK_DIR/build-lib-arch.sh" iPhoneSimulator6.1 i686-apple-darwin10 i386    cpu_unknown

echo "creating fat lib: $INSTALL_DIR"
mkdir -p "$INSTALL_DIR/lib"

cp -RP "$BUILD_DIR/armv7/install/include" "$INSTALL_DIR/include"

$lipo \
-arch armv7   "$BUILD_DIR/armv7/install/lib/$LIB_NAME.a" \
-arch armv7s  "$BUILD_DIR/armv7s/install/lib/$LIB_NAME.a" \
-arch i386    "$BUILD_DIR/i386/install/lib/$LIB_NAME.a" \
-create -output "$INSTALL_DIR/lib/$LIB_NAME.a"

echo "COMPLETE: $LIB_NAME"
