#!/usr/bin/env bash
# Copyright 2013 George King.
# Permission to use this file is granted in libqk/licenset.txt.

source ./build-lib-common.sh

lipo=lipo

"$qk_root/build-lib-arch.sh" MacOSX10.8 i686-apple-darwin x86_64

echo "creating fat lib: $dst_path"
mkdir -p "$dst_path/lib"

cp -RP build-x86_64/install/include "$dst_path/include"

$lipo \
-arch x86_64 build-x86_64/install/lib/$lib_name.a \
-create -output "$dst_path/lib/$lib_name.a"
