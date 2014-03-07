#!/usr/bin/env bash
# Copyright 2013 George King.
# Permission to use this file is granted in libqk/license.txt.

# build fat static libs from autoconf/make based source.

# NOTE:
# libjpegturbo sources are preconfigured with an older, incompatible version of autotools.
# in order to compile 1.3.0, you must install the gnu autoconf toolchain (with some dependencies), and then run the following in the libjpegturbo root dir:
# $ autoreconf -fiv
# however, be aware that the gnu toolchain may not work for other libraries.
# the safest approach is to install the gnu tools in /usr/local/gnu, then add it to the path only for the autoreconf step:
# $ export PATH=/usr/local/gnu:$PATH
# once this is complete, close that shell and run this script in a new shell.


error() { echo 'error:' "$@" 1>&2; exit 1; }

cd $(dirname $0)/..

(( ${#@} >= 3 )) || error "usage: sqlite3-root png-root jpeg-turbo-root"

export BUILD_QUIET='-quiet' # either -quiet or nothing.
export BUILD_PARALLEL='-j8' # passed to make.

set -e

scripts/build-lib.sh mac sqlite3 $1 "" -Oz
scripts/build-lib.sh ios sqlite3 $1 "" -Oz
scripts/build-lib.sh mac png     $2 "" -O3
scripts/build-lib.sh ios png     $2 "" -O3
scripts/build-lib.sh mac turbojpeg $3 "--with-jpeg8" -O3
scripts/build-lib.sh ios turbojpeg $3 "--with-jpeg8" -O3

