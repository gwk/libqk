#!/usr/bin/env bash
# Copyright 2013 George King.
# Permission to use this file is granted in libqk/license.txt.

# build a static lib from autoconf/make based source.
# this script is sourced by the platform-specific scripts.

set -e

error() { echo 'error:' "$@" 1>&2; exit 1; }

echo
echo "build-lib-common.sh: $@"

export OS="$1"; shift
export NAME="$1"; shift
export CC_OPT="$1"; shift
export SRC_DIR="$1"; shift
export INSTALL_DIR="$PWD/$1"; shift
export CONFIG_ARGS="$@"

export BUILD_DIR="build/$OS-$NAME"
export DEV_DIR=/Applications/Xcode.app/Contents/Developer
export TOOL_DIR=$DEV_DIR/Toolchains/XcodeDefault.xctoolchain/usr/bin

build_cmd="scripts/build-lib-arch.sh"

echo "
OS: $OS
NAME: $NAME
CC_OPT: $CC_OPT
SRC_DIR: $SRC_DIR
INSTALL_DIR: $INSTALL_DIR
CONFIG_ARGS: $CONFIG_ARGS

BUILD_DIR: $BUILD_DIR
DEV_DIR: $DEV_DIR
TOOL_DIR: $TOOL_DIR
"

[[ -d "$INSTALL_DIR" ]] && rm -rf "$INSTALL_DIR"
mkdir -p "$INSTALL_DIR/lib"

#### MAC ####
if [[ $OS == 'mac' ]]; then
  export PLATFORM_TOOL_DIR=$DEV_DIR/usr/bin
  lipo=lipo

  "$build_cmd" MacOSX10.9 x86_64-apple-darwin x86_64

  # fat lib is not necessary with only one arch, but this is how to do it.
  echo "creating fat lib: $INSTALL_DIR"
  cp -RP "$BUILD_DIR/x86_64/install/include" "$INSTALL_DIR/include"

  $lipo \
  -arch x86_64 "$BUILD_DIR/x86_64/install/lib/lib$NAME.a" \
  -create -output "$INSTALL_DIR/lib/lib$NAME.a"

#### IOS ####
elif [[ $OS == 'ios' ]]; then
  # compilers for simulator are in iPhoneOS, not iPhoneSimulator, so this is necessary.
  export PLATFORM_TOOL_DIR=$DEV_DIR/Platforms/iPhoneOS.platform/Developer/usr/bin
  lipo=$PLATFORM_TOOL_DIR/lipo
  [[ -f $lipo ]] || error "missing lipo: $lipo"

  "$build_cmd" iPhoneOS7.0         arm-apple-darwin10    armv7
  "$build_cmd" iPhoneOS7.0         arm-apple-darwin10    armv7s
  "$build_cmd" iPhoneOS7.0         arm-apple-darwin10    arm64
  "$build_cmd" iPhoneSimulator7.0  i686-apple-darwin10   i386
  "$build_cmd" iPhoneSimulator7.0  x86_64-apple-darwin   x86_64

  echo "creating fat lib: $INSTALL_DIR"
  # copy headers; API should be identical across archs should so any one will do.
  cp -RP "$BUILD_DIR/armv7/install/include" "$INSTALL_DIR/include"

  $lipo \
  -arch armv7   "$BUILD_DIR/armv7/install/lib/lib$NAME.a" \
  -arch armv7s  "$BUILD_DIR/armv7s/install/lib/lib$NAME.a" \
  -arch arm64   "$BUILD_DIR/arm64/install/lib/lib$NAME.a" \
  -arch i386    "$BUILD_DIR/i386/install/lib/lib$NAME.a" \
  -arch x86_64  "$BUILD_DIR/x86_64/install/lib/lib$NAME.a" \
  -create -output "$INSTALL_DIR/lib/lib$NAME.a"
else
  error "unknown OS: $OS"
fi

