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

(( ${#@} >= 3 )) || error "usage: sqlite3-root png-root jpeg-turbo-root [--quiet]"

sqlite3=$1; shift
png=$1; shift
turbojpeg=$1; shift
export QUIET=$1; shift

if [[ "$QUIET" == '-quiet' ]]; then
  echo "note: quiet mode enabled."
elif [[ -n "$QUIET" ]]; then
  error "final arg must be '-quiet' or empty; actual: '$QUIET'"
fi

# note: version string compare is not great, but catches the common case.
nasm_version_req='version 2.10.00'
nasm_version=$(nasm -v | egrep --only-matching --max-count=1 'version [0-9]+(\.[0-9]+)*')
echo "nasm $nasm_version (above $nasm_version_req required)"
[[ "$nasm_version" > "$nasm_version_req" ]] || error "modern nasm required: $nasm_version_req; using $(nasm -v)"

# gas-preprocessor cleans up gas code for clang, which does not understand gnu extensions.
# this is in the scripts directory, so prepend that to PATH.
export PATH="$PWD/scripts:$PATH"

set -e

build_lib() {
  local os=$1; shift
  local name="$1"; shift
  local cc_opt=$1; shift
  local config_args="$@"
  eval local src_dir=\$$name # get src_dir from the argument named 'name'.
  local install_dir="submodules/libqk-built-$os/$name"
  [[ -d "$src_dir" ]] || {
    echo "skipping missing source dir for $name: $src_dir"
    return
  }
  echo "building $os $name: $src_dir"
  scripts/build-lib.sh $os $name $cc_opt "$src_dir" "$install_dir" $config_args

  echo "
FAT LIB COMPLETE: $os $name
----------------

"
}

build_lib mac sqlite3 -Oz
build_lib ios sqlite3 -Oz
build_lib mac png -O3
build_lib ios png -O3
#build_lib mac turbojpeg -O3 --with-jpeg8
build_lib ios turbojpeg -O3 --with-jpeg8  # TODO: this should now work # --with-gas-preprocessor

