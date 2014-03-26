#!/usr/bin/env bash

set -ex
$0/../build-libs.sh \
~/external/glm* \
~/external/sqlite-autoconf-3* \
~/external/libpng-1.* \
~/external/libjpeg-turbo-1.3* \
~/external/opencv-2.*
