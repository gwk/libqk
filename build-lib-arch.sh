#!/usr/bin/env bash
# Copyright 2013 George King.
# Permission to use this file is granted in libqk/license.txt.

# build a static lib from autoconf/make based source.
# invoke this from the lib source root (i.e. where the configure script is).

set -e

error() { echo 'error:' "$@" 1>&2; exit 1; }


sdk=$1; shift
platform=${sdk%%[0-9]*}
host=$1; shift
arch=$1; shift
config_args="$@"

echo
echo "build-lib-arch.sh: $sdk $platform $host $arch $config_args"

dev_dir=/Applications/Xcode.app/Contents/Developer
tool_dir=$dev_dir/Toolchains/XcodeDefault.xctoolchain/usr/bin
platform_dir=$dev_dir/Platforms/$platform.platform
sdk_root=$platform_dir/Developer/SDKs/$sdk.sdk

for n in dev_dir tool_dir platform_dir sdk_root; do
  eval v=\$$n
  echo "$n: $v"
  [[ -d "$v" ]] || error "bad $n"
done

mkdir -p build-$arch
cd build-$arch
rm -rf * # clean
../configure \
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

echo
