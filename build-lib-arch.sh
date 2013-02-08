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

cc_gcc=$PLATFORM_TOOL_DIR/$host-llvm-gcc-4.2
cxx_gcc=$PLATFORM_TOOL_DIR/$host-llvm-g++-4.2

eval cc=\$cc_$CC_NAME
eval cxx=\$cxx_$CC_NAME

c_flags="-O3 -arch $arch"
as=$cc
ld=$TOOL_DIR/ld
libtool=$TOOL_DIR/libtool


if [[ $platform == 'iPhoneOS' ]]; then
  c_flags="-O3 -arch $arch"
  as="gas-preprocessor.pl $cc"
  # original flags from turbojpg gcc recipe:
  #c_flags="-O3 -march=$arch -mfloat-abi=softfp -mfpu=neon -mcpu=$cpu -mtune=$cpu"
fi

echo "
sdk: $sdk; host: $host; arch: $arch; cpu: $cpu;
CC_NAME: $CC_NAME
platform: $platform
cc: $cc
cxx: $cxx
as: $as
ld: $ld
libtool: $libtool
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
CPP="$cc -E" \
CC="$cc" \
CXXCPP="$cxx -E" \
CXX="$cxx" \
CCAS="$as" \
LD="$ld -arch $arch" \
LIBTOOL="$libtool" \
CPPFLAGS="   -I$sdk_dir/usr/include" \
CXXCPPFLAGS="-I$sdk_dir/usr/include" \
CFLAGS="     -I$sdk_dir/usr/include  -isysroot $sdk_dir $c_flags" \
CXXFLAGS="   -I$sdk_dir/usr/include  -isysroot $sdk_dir $c_flags" \
LDFLAGS="    -L$sdk_dir/usr/lib      -isysroot $sdk_dir" \
$CONFIG_ARGS \
$QUIET

make $QUIET
make install $QUIET
set +x

echo "----
COMPLETE: $sdk $host $arch $SRC_DIR
"
