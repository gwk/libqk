#!/usr/bin/env bash
# Copyright 2013 George King.
# Permission to use this file is granted in license-libqk.txt (ISC License).

# build a static lib from autoconf/make based source.
# this script is sourced by the platform-specific scripts.

set -e

error() { echo 'error:' "$@" 1>&2; exit 1; }

cd $(dirname $0)/..
echo
echo "$0 $@"

if [[ "$BUILD_QUIET" == '--quiet' ]]; then
  echo "quiet mode enabled."
elif [[ -n "$BUILD_QUIET" ]]; then
  error "if BUILD_QUIET is defined it must be '--quiet'; actual: '$BUILD_QUIET'"
fi

# note: version string compare is not great, but catches the common case.
nasm_version_req='version 2.10.00'
nasm_version=$(nasm -v | egrep --only-matching --max-count=1 'version [0-9]+(\.[0-9]+)*')
[[ "$nasm_version" > "$nasm_version_req" ]] || error "modern nasm required: $nasm_version_req; found $nasm_version"

# gas-preprocessor cleans up gas code for clang, which does not understand gnu extensions.
# this is required for libjpeg-turbo.
# this is in the scripts directory, so prepend that to PATH.
export PATH="$PWD/scripts:$PATH"

export OS=$1; shift
export NAME=$1; shift
export SRC_DIR=$1; shift
export BUILD_SCRIPT=$1; shift
export CONFIG_ARGS=$1; shift
export CC_FLAGS=$1; shift
export CC_AS_FLAGS=$1; shift

export DEV_DIR=/Applications/Xcode.app/Contents/Developer
export TOOL_DIR=$DEV_DIR/Toolchains/XcodeDefault.xctoolchain/usr/bin
export BUILD_DIR="_build/$OS-$NAME"
export INSTALL_DIR="submodules/libqk-built-$OS"

# even with the quiet flag, libtool is verbose, so redirect output.
if [[ -n "$BUILD_QUIET" ]]; then
  export BUILD_OUT=/dev/null
else
  export BUILD_OUT=/dev/stdout
fi

if [[ $SRC_DIR == "-" ]]; then
  echo "skipping $NAME (SRC_DIR: $SRC_DIR)."
  exit
fi

build_cmd="scripts/$BUILD_SCRIPT"

echo "
OS: $OS
NAME: $NAME
SRC_DIR: $SRC_DIR
BUILD_SCRIPT: $BUILD_SCRIPT
CONFIG_ARGS: $CONFIG_ARGS
CC_FLAGS: $CC_FLAGS
DEV_DIR: $DEV_DIR
TOOL_DIR: $TOOL_DIR
BUILD_DIR: $BUILD_DIR
INSTALL_DIR: $INSTALL_DIR
BUILD_OUT: $BUILD_OUT
build_cmd: $build_cmd
"

mkdir -p "$INSTALL_DIR/lib"

echo "copying licenses..."
# this is redundant in that every build copies all licenses, but it is inconsequential.
cp -r licenses/ "$INSTALL_DIR/licenses"

if [[ $OS == 'mac' ]]; then
  export PLATFORM_TOOL_DIR=$DEV_DIR/usr/bin
  lipo=lipo

  "$build_cmd" MacOSX10.9 x86_64-apple-darwin x86_64 "$@"

  # fat lib is not necessary with only one arch, but might as well for consistency.
  echo "creating fat lib for $NAME: $INSTALL_DIR"

  $lipo \
  -create \
  -arch x86_64 "$BUILD_DIR/x86_64/install/lib/lib$NAME.a" \
  -output "$INSTALL_DIR/lib/lib$NAME.a"


elif [[ $OS == 'ios' ]]; then
  # compilers for simulator are in iPhoneOS, not iPhoneSimulator, so this is necessary.
  export PLATFORM_TOOL_DIR=$DEV_DIR/Platforms/iPhoneOS.platform/Developer/usr/bin
  lipo=$PLATFORM_TOOL_DIR/lipo
  [[ -f $lipo ]] || error "missing lipo: $lipo"

  "$build_cmd" iPhoneOS7.1        arm-apple-darwin10  armv7   "$@"
  "$build_cmd" iPhoneOS7.1        arm-apple-darwin10  armv7s  "$@"
  "$build_cmd" iPhoneOS7.1        arm-apple-darwin10  arm64   "$@"
  "$build_cmd" iPhoneSimulator7.1 i686-apple-darwin10 i386    "$@"
  "$build_cmd" iPhoneSimulator7.1 x86_64-apple-darwin x86_64  "$@"

  echo "creating fat lib for $NAME in: $INSTALL_DIR"

  $lipo \
  -create \
  -arch armv7   "$BUILD_DIR/armv7/install/lib/lib$NAME.a" \
  -arch armv7s  "$BUILD_DIR/armv7s/install/lib/lib$NAME.a" \
  -arch arm64   "$BUILD_DIR/arm64/install/lib/lib$NAME.a" \
  -arch i386    "$BUILD_DIR/i386/install/lib/lib$NAME.a" \
  -arch x86_64  "$BUILD_DIR/x86_64/install/lib/lib$NAME.a" \
  -output "$INSTALL_DIR/lib/lib$NAME.a"
else
  error "unknown OS: $OS"
fi

echo "copying headers..."
# assume there is always an x86_64 build, and that headers are identical for all builds.
# TODO: actually diff the various arch include trees.
mkdir -p "$INSTALL_DIR/include"
# note the trailing slash of src; this causes contents to be copied, not the dir itself.
cp -RP "$BUILD_DIR/x86_64/install/include/" "$INSTALL_DIR/include/"

echo "
FAT LIB COMPLETE: $OS $NAME
----------------

"
