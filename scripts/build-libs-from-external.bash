#!/usr/bin/env bash
# Copyright 2013 George King.
# Permission to use this file is granted in license-libqk.txt (ISC License).

set -ex
$0/../build-libs.bash \
~/external/glm* \
~/external/sqlite-autoconf-3* \
~/external/libpng-1.* \
~/external/libjpeg-turbo-1.3* \
~/external/opencv-2.*
