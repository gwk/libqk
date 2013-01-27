#!/usr/bin/env bash
# Copyright 2013 George King.
# Permission to use this file is granted in libqk/license.txt.

source ./build-lib-common.sh

dev_dir=/Applications/Xcode.app/Contents/Developer
platform_dir=$dev_dir/Platforms/iPhoneOS.platform
lipo=$platform_dir/Developer/usr/bin/lipo
[[ -f $lipo ]] || error "missing lipo: $lipo"

"$qk_root/build-lib-arch.sh" iPhoneOS6.0 arm-apple-darwin armv7
"$qk_root/build-lib-arch.sh" iPhoneOS6.0 arm-apple-darwin armv7s
"$qk_root/build-lib-arch.sh" iPhoneSimulator6.0 i686-apple-darwin i386 

echo "creating fat lib: $dst_path"
mkdir -p "$dst_path/lib"

cp -RP build-armv7/install/include "$dst_path/include"

$lipo \
-arch armv7 build-armv7/install/lib/$lib_name.a \
-arch armv7s build-armv7s/install/lib/$lib_name.a \
-arch i386 build-i386/install/lib/$lib_name.a \
-create -output "$dst_path/lib/$lib_name.a"
