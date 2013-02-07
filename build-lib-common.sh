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

export SRC_DIR="$1"; shift
export LIB_NAME="$1"; shift
export CC_NAME="$1"; shift
export INSTALL_DIR="$PWD/$1"; shift
export CONFIG_ARGS="$@"

export QK_DIR="$PWD"
export BUILD_DIR="$QK_DIR/build/$LIB_NAME"
export DEV_DIR=/Applications/Xcode.app/Contents/Developer
export TOOL_DIR=$DEV_DIR/Toolchains/XcodeDefault.xctoolchain/usr/bin

echo "
LIB_NAME: $LIB_NAME
CC_NAME: $CC_NAME
INSTALL_DIR: $INSTALL_DIR
CONFIG_ARGS: $CONFIG_ARGS
QK_DIR: $QK_DIR
BUILD_DIR: $BUILD_DIR
DEV_DIR: $DEV_DIR
TOOL_DIR: $TOOL_DIR
"

rm -rf "$INSTALL_DIR"
