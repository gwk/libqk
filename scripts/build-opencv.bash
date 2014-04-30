#!/usr/bin/env bash
# Copyright 2013 George King.
# Permission to use this file is granted in license-libqk.txt (ISC License).

# build opencv from source using cmake and xcodebuild.
# this script is invoked by build-lib.bash.

set -e
echo "$0 $@"
error() { echo 'error:' "$@" 1>&2; exit 1; }

sdk=$1;   shift
host=$1;  shift
arch=$1;  shift
[[ -z "$@" ]] || error "excess arguments: $@"

platform=${sdk%%[0-9]*}
platform_lc=$(echo $platform | tr '[:upper:]' '[:lower:]')
sdk_version=${sdk##$platform}
sdk_version_0=${sdk_version%%[0-9]}0

if [[ $OS == 'mac' ]]; then
  xc_deployment_target="MACOSX_DEPLOYMENT_TARGET=$sdk_version"
elif [[ $OS == 'ios' ]]; then
  xc_deployment_target="IPHONEOS_DEPLOYMENT_TARGET=$sdk_version_0"
else
  error "unkown OS: $OS"
fi


echo "\
platform: $platform
platform_lc: $platform_lc
platform_uc: $platform_uc
sdk_version: $sdk_version
sdk_version_0: $sdk_version_0
xc_deployment_target: $xc_deployment_target
"

src_dir=$PWD

mkdir -p "$BUILD_DIR/$arch"
cd "$BUILD_DIR/$arch"
rm -rf modules install # don't remove everything because cmake setup tests are slow.

[[ $OS == 'ios' ]] && cmake_toolchain_file="-DCMAKE_TOOLCHAIN_FILE=platforms/ios/cmake/Toolchains/Toolchain-"$platform"_Xcode.cmake"

ocv_build_apps=OFF
ocv_perf_tests=OFF
ocv_debug_info=OFF

echo "running cmake..."
set -x

# note: if we want to link against external libjpeg build:
#-DWITH_JPEG=ON -DBUILD_JPEG=OFF -DJPEG_INCLUDE_DIR=/path/to/libjepeg-turbo/include/ -DJPEG_LIBRARY=/path/to/libjpeg-turbo/lib/libjpeg.a /path/to/OpenCV


cmake \
-GXcode \
-DCMAKE_BUILD_TYPE=Release \
-DWITH_1394=OFF \
-DWITH_AVFOUNDATION=OFF \
-DWITH_CARBON=OFF \
-DWITH_CUDA=OFF \
-DWITH_CUFFT=OFF \
-DWITH_CUBLAS=OFF \
-DWITH_EIGEN=ON \
-DWITH_FFMPEG=OFF \
-DWITH_GSTREAMER=OFF \
-DWITH_GTK=OFF \
-DWITH_IMAGEIO=OFF \
-DWITH_IPP=OFF \
-DWITH_JASPER=OFF \
-DWITH_JPEG=OFF \
-DWITH_OPENEXR=OFF \
-DWITH_OPENGL=OFF \
-DWITH_OPENNI=OFF \
-DWITH_PNG=OFF \
-DWITH_PVAPI=OFF \
-DWITH_GIGEAPI=OFF \
-DWITH_QT=OFF \
-DWITH_QUICKTIME=OFF \
-DWITH_TBB=OFF \
-DWITH_OPENMP=OFF \
-DWITH_CSTRIPES=OFF \
-DWITH_TIFF=OFF \
-DWITH_UNICAP=OFF \
-DWITH_V4L=OFF \
-DWITH_LIBV4L=OFF \
-DWITH_DSHOW=OFF \
-DWITH_MSMF=OFF \
-DWITH_XIMEA=OFF \
-DWITH_XINE=OFF \
-DWITH_OPENCL=OFF \
-DWITH_OPENCLAMDFFT=OFF \
-DWITH_OPENCLAMDBLAS=OFF \
-DWITH_INTELPERC=OFF \
-DBUILD_SHARED_LIBS=OFF \
-DBUILD_opencv_apps=$ocv_build_apps \
-DBUILD_ANDROID_EXAMPLES=OFF \
-DBUILD_DOCS=OFF \
-DBUILD_EXAMPLES=OFF \
-DBUILD_PACKAGE=OFF \
-DBUILD_PERF_TESTS=$ocv_perf_tests \
-DBUILD_WITH_DEBUG_INFO=$ocv_debug_info \
-DBUILD_FAT_JAVA_LIB=OFF \
-DBUILD_ANDROID_PACKAGE=OFF \
-DBUILD_ZLIB=OFF \
-DBUILD_TIFF=OFF \
-DBUILD_JASPER=OFF \
-DBUILD_JPEG=OFF \
-DBUILD_PNG=OFF \
-DBUILD_OPENEXR=OFF \
-DBUILD_TBB=OFF \
-DENABLE_OMIT_FRAME_POINTER=OFF \
-DBUILD_opencv_gpu=OFF \
-DBUILD_opencv_gpu=OFF \
-DBUILD_opencv_highgui=OFF \
-DBUILD_opencv_legacy=OFF \
-DBUILD_opencv_nonfree=OFF \
-DBUILD_opencv_python=OFF \
-DBUILD_opencv_ts=OFF \
-DBUILD_opencv_videostab=OFF \
-DBUILD_opencv_world=ON \
-DCMAKE_BUILD_TYPE=Release \
$cmake_toolchain_file \
-DCMAKE_INSTALL_PREFIX="$PWD/install" \
$SRC_DIR > $BUILD_OUT

echo "running xcode build..."
xcodebuild \
$xc_deployment_target \
ARCHS=$arch \
-sdk $platform_lc \
-jobs $BUILD_JOBS \
-configuration Release \
-target ALL_BUILD \
build > $BUILD_OUT

echo "running xcode install..."
xcodebuild \
$xc_deployment_target \
ARCHS=$arch \
-sdk $platform_lc \
-configuration Release \
-target install \
install > $BUILD_OUT

echo "copying files..."
cp modules/world/UninstalledProducts/libopencv_world.a install/lib/libopencv.a
rm -rf install/include/opencv # remove deprecated version 1 headers.

echo "
OPENCV BUILD COMPLETE: $OS $NAME $sdk $host $arch
--------------
"
