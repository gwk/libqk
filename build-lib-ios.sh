#!/usr/bin/env bash
# Copyright 2013 George King.
# Permission to use this file is granted in libqk/license.txt.

source ./build-lib-common.sh

dev_dir=/Applications/Xcode.app/Contents/Developer
platform_dir=$dev_dir/Platforms/iPhoneOS.platform
lipo=$platform_dir/Developer/usr/bin/lipo
[[ -f $lipo ]] || error "missing lipo: $lipo"

"$qk_root/build-lib-arch.sh" "$src_dir" "$build_dir" iPhoneOS6.0 arm-apple-darwin armv7
"$qk_root/build-lib-arch.sh" "$src_dir" "$build_dir" iPhoneOS6.0 arm-apple-darwin armv7s
"$qk_root/build-lib-arch.sh" "$src_dir" "$build_dir" iPhoneSimulator6.0 i686-apple-darwin i386 

echo "creating fat lib: $install_dir"
mkdir -p "$install_dir/lib"

cp -RP "$build_dir/armv7/install/include" "$install_dir/include"

$lipo \
-arch armv7   "$build_dir/armv7/install/lib/$lib_name.a" \
-arch armv7s  "$build_dir/armv7s/install/lib/$lib_name.a" \
-arch i386    "$build_dir/i386/install/lib/$lib_name.a" \
-create -output "$install_dir/lib/$lib_name.a"
