#!/usr/bin/env bash
# Copyright 2013 George King.
# Permission to use this file is granted in libqk/license.txt.

# build a static lib from autoconf/make based source.
# invoke this from the lib source root (i.e. where the configure script is).

set -e

error() { echo 'error:' "$@" 1>&2; exit 1; }

echo
echo "build-lib-arch.sh: $@"

src_dir=$1; shift
build_dir=$1; shift
sdk=$1; shift
host=$1; shift
arch=$1; shift
config_args="$@"
platform=${sdk%%[0-9]*}

echo "build-lib-arch.sh:"
echo "src_dir: $src_dir"
echo "build_dir: $build_dir"
echo "sdk: $sdk; platform: $platform; host: $host;  arch: $arch"
echo "config args: $config_args"
echo "----"

dev_dir=/Applications/Xcode.app/Contents/Developer
tool_dir=$dev_dir/Toolchains/XcodeDefault.xctoolchain/usr/bin
platform_dir=$dev_dir/Platforms/$platform.platform
sdk_root=$platform_dir/Developer/SDKs/$sdk.sdk

for n in dev_dir tool_dir platform_dir sdk_root src_dir; do
  eval v=\$$n
  echo "$n: $v"
  [[ -d "$v" ]] || error "bad $n"
done

mkdir -p "$build_dir/$arch"
cd "$build_dir/$arch"
rm -rf * # clean aggressively
"$src_dir/configure" \
--prefix="$PWD/install" \
--host=$host \
--disable-shared \
--enable-static \
CC=$tool_dir/clang \
LD=$tool_dir/ld \
CPPFLAGS="-I$sdk_root/usr/include/" \
CFLAGS="-I$sdk_root/usr/include/ -arch $arch -isysroot $sdk_root -O3" \
LDFLAGS="-L$SDKROOT/usr/lib/" \
$config_args

make
make install

echo "----"
echo
