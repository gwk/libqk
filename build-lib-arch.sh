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

libtool=$TOOL_DIR/libtool

cc_clang=$TOOL_DIR/clang
cxx_clang=$TOOL_DIR/clang++
ld_clang=$TOOL_DIR/ld

cc_gcc=$PLATFORM_TOOL_DIR/$host-llvm-gcc-4.2
cxx_gcc=$PLATFORM_TOOL_DIR/$host-llvm-g++-4.2
ld_gcc=$cc_gcc

c_arch_clang="-arch $arch"
c_arch_gcc="-march=$arch"

c_flags_clang=""
c_flags_gcc=""

if [[ $platform == 'iPhoneOS' ]]; then
  c_flags_gcc="-mfloat-abi=softfp -mfpu=neon -mcpu=$cpu -mtune=$cpu"
fi


eval cc=\$cc_$CC_NAME
eval cxx=\$cxx_$CC_NAME
eval ld=\$ld_$CC_NAME
eval c_arch=\$c_arch_$CC_NAME
eval c_flags=\$c_flags_$CC_NAME


as=$cc
if [[ $platform == 'iPhoneOS' ]]; then
  as="gas-preprocessor.pl $cc"
fi


echo "
sdk: $sdk
host: $host
arch: $arch
cpu: $cpu;
CC_NAME: $CC_NAME
platform: $platform
libtool: $libtool
cc: $cc
cxx: $cxx
as: $as
ld: $ld
c_arch: $c_arch
c_flags: $c_flags
config_args: $config_args
----"


for n in SRC_DIR DEV_DIR TOOL_DIR PLATFORM_TOOL_DIR QK_DIR platform_dir sdk_dir; do
  eval v=\$$n
  echo "$n: $v"
  [[ -d "$v" ]] || error "bad $n"
done

mkdir -p "$BUILD_DIR/$arch"
cd "$BUILD_DIR/$arch"
rm -rf * # clean aggressively
rm -rf .deps .libs # hidden directories

set -x
"$SRC_DIR/configure" \
--disable-dependency-tracking \
--prefix="$PWD/install" \
--host=$host \
--enable-static \
--disable-shared \
LIBTOOL="$libtool" \
CPP="$cc -E" \
CC="$cc" \
CXXCPP="$cxx -E" \
CXX="$cxx" \
CCAS="$as" \
LD="$ld" \
CPPFLAGS="   -I$sdk_dir/usr/include" \
CXXCPPFLAGS="-I$sdk_dir/usr/include" \
CFLAGS="     -I$sdk_dir/usr/include  -isysroot $sdk_dir $CC_OPT $c_arch $c_flags" \
CXXFLAGS="   -I$sdk_dir/usr/include  -isysroot $sdk_dir $CC_OPT $c_arch $c_flags" \
LDFLAGS="    -L$sdk_dir/usr/lib      -isysroot $sdk_dir $c_arch" \
$CONFIG_ARGS \
$QUIET

set +x

# make does not seem to respond to --quiet or --silent despite man page.
if [[ -n "$QUIET" ]]; then
  OUT=/dev/null
else
  OUT=/dev/stdout
fi

echo "running make..."
make > $OUT
echo "running make install..."
make install > $OUT

echo "----
COMPLETE: $sdk $host $arch $SRC_DIR
"
