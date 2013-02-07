#!/usr/bin/env bash
# Copyright 2013 George King.
# Permission to use this file is granted in libqk/license.txt.

# build a static lib from autoconf/make based source.
# invoke this from the lib source root (i.e. where the configure script is).

set -e

error() { echo 'error:' "$@" 1>&2; exit 1; }

echo "build-lib-arch.sh: $@"

sdk=$1;   shift
host=$1;  shift
arch=$1;  shift
cpu=$1;   shift

platform=${sdk%%[0-9]*}
platform_dir=$DEV_DIR/Platforms/$platform.platform
sdk_dir=$platform_dir/Developer/SDKs/$sdk.sdk

cc_clang=$TOOL_DIR/clang
cxx_clang=$TOOL_DIR/clang++
flags_clang="-O4 -arch $arch"

cc_gcc=$PLATFORM_TOOL_DIR/$host-llvm-gcc-4.2
cxx_gcc=$PLATFORM_TOOL_DIR/$host-llvm-g++-4.2
if [[ $platform == 'iPhoneOS' ]]; then
  flags_gcc="-O3 -march=$arch -mfloat-abi=softfp -mfpu=neon -mcpu=$cpu -mtune=$cpu"
elif [[ $platform == 'iPhoneSimulator' ]]; then
  flags_gcc="-O3 -march=$arch"
elif [[ $platform == 'MacOSX' ]]; then
  flags_gcc="-O3 -march=$arch"
else
  error "bad platform: $platform"
fi


eval cc=\$cc_$CC_NAME
eval cxx=\$cxx_$CC_NAME
eval flags=\$flags_$CC_NAME

ld=$TOOL_DIR/ld

echo "
sdk: $sdk; host: $host; arch: $arch; cpu: $cpu;
CC_NAME: $CC_NAME
platform: $platform
cc: $cc
cxx: $cxx
flags: $flags
config args: $config_args
----"


for n in SRC_DIR DEV_DIR TOOL_DIR PLATFORM_TOOL_DIR QK_DIR platform_dir sdk_dir; do
  eval v=\$$n
  echo "$n: $v"
  [[ -d "$v" ]] || error "bad $n"
done

set -x
mkdir -p "$BUILD_DIR/$arch"
cd "$BUILD_DIR/$arch"
rm -rf * # clean aggressively
"$SRC_DIR/configure" \
--prefix="$PWD/install" \
--host=$host \
--enable-static \
--disable-shared \
CC="$cc" \
CPP="$cc -E" \
CXX="$cxx" \
LD="$cc" \
CPPFLAGS="-I$sdk_dir/usr/include" \
CFLAGS="  -I$sdk_dir/usr/include  -isysroot $sdk_dir $flags" \
LDFLAGS=" -L$sdk_dir/usr/lib      -isysroot $sdk_dir $flags" \
$CONFIG_ARGS > "$OUT"

make > "$OUT"
make install > "$OUT"
set +x

echo "----
COMPLETE: $sdk $host $arch $SRC_DIR
"
