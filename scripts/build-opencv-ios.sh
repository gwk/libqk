#!/usr/bin/env bash
# Copyright 2013 George King.
# Permission to use this file is granted in libqk/license.txt.

# build opencv from source using cmake and xcodebuild.
# this script is invoked by build-lib.sh.

set -e
echo "$0 $@"
error() { echo 'error:' "$@" 1>&2; exit 1; }

sdk=$1;   shift
host=$1;  shift
arch=$1;  shift
[[ -z "$@" ]] || error "excess arguments: $@"

platform=${sdk%%[0-9]*}
xcode_sdk=$(echo $platform | tr '[:upper:]' '[:lower:]') # lowercase.

echo "\
platform: $platform
xcode_sdk: $xcode_sdk
"

# to specify an external libjpeg build:
#-DWITH_JPEG=ON -DBUILD_JPEG=OFF -DJPEG_INCLUDE_DIR=/path/to/libjepeg-turbo/include/ -DJPEG_LIBRARY=/path/to/libjpeg-turbo/lib/libjpeg.a /path/to/OpenCV

src_dir=$PWD

mkdir -p "$BUILD_DIR/$arch"
cd "$BUILD_DIR/$arch"
rm -rf modules install # don't remove everything because cmake setup tests are slow.

[[ -z "$BUILD_QUIET" ]] && set -x

echo "running cmake..."
cmake \
-GXcode \
-DBUILD_opencv_world=NO \
-DCMAKE_BUILD_TYPE=Release \
-DCMAKE_TOOLCHAIN_FILE=platforms/ios/cmake/Toolchains/Toolchain-"$platform"_Xcode.cmake \
-DWITH_JPEG=OFF \
-DWITH_PNG=OFF \
-DWITH_IMAGEIO=OFF \
-DBUILD_opencv_world=ON \
-DBUILD_opencv_highgui=OFF \
-DBUILD_opencv_nonfree=OFF \
-DBUILD_opencv_legacy=OFF \
-DBUILD_ZLIB=OFF \
-DBUILD_TIFF=OFF \
-DBUILD_JASPER=OFF \
-DBUILD_JPEG=OFF \
-DBUILD_PNG=OFF \
-DBUILD_OPENEXR=OFF \
-DCMAKE_INSTALL_PREFIX="$PWD/install" \
$SRC_DIR > $BUILD_OUT


echo "running xcode build..."
xcodebuild \
IPHONEOS_DEPLOYMENT_TARGET=7.0 \
ARCHS=$arch \
-sdk $xcode_sdk \
-parallelizeTargets \
-jobs $BUILD_JOBS \
-configuration Release \
-target ALL_BUILD \
build > $BUILD_OUT

echo "running xcode install..."
xcodebuild \
IPHONEOS_DEPLOYMENT_TARGET=7.0 \
ARCHS=$arch \
-sdk $xcode_sdk \
-configuration Release \
-target install \
install > $BUILD_OUT

echo "copying files..."
cp modules/world/UninstalledProducts/libopencv_world.a install/lib/libopencv.a
rm -rf install/include/opencv # remove deprecated version 1 headers.

echo "
BUILD COMPLETE: $OS $NAME $sdk $host $arch
--------------
"
