#!/usr/bin/env bash
# Copyright 2013 George King.
# Permission to use this file is granted in libqk/license.txt.

source ./build-lib-common.sh

lipo=lipo

"$qk_root/build-lib-arch.sh" "$src_dir" "$build_dir" MacOSX10.8 i686-apple-darwin x86_64

echo
echo "creating fat lib: $install_dir"
mkdir -p "$install_dir/lib"

cp -RP "$build_dir/x86_64/install/include" "$install_dir/include"

# lipo is not necessary with only one arch, but this is how to do it.
$lipo \
-arch x86_64 "$build_dir/x86_64/install/lib/$lib_name.a" \
-create -output "$install_dir/lib/$lib_name.a"
