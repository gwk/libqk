#!/usr/bin/env bash
# Copyright 2013 George King.
# Permission to use this file is granted in libqk/license.txt.

# build fat static libs from autoconf/make based source.

set -e

error() { echo 'error:' "$@" 1>&2; exit 1; }

[[ $0 == "./build-libs.sh" ]] || error "must invoke as ./build-libs.sh"

(( ${#@} >= 3 )) || error "usage: sqlite3 png jpeg-turbo [--quiet]"

sqlite3=$1;   shift
png=$1;       shift
turbojpeg=$1;  shift
export QUIET=$1;

libqk="$PWD"

# note: string compare is not great, but catches the common case.
nasm_version_req='version 2.10.00'
nasm_version=$(nasm -v | egrep --only-matching --max-count=1 'version [0-9]+(\.[0-9]+)*')
echo "nasm $nasm_version (above $nasm_version_req required)"
[[ "$nasm_version" > "$nasm_version_req" ]] || error "modern nasm required: $nasm_version_req; using $(nasm -v)"

# libjpeg-turbo requires gas-preprocessor, obtained from https://github.com/yuvi/gas-preprocessor
[[ -r "$libqk/tools/gas-preprocessor.pl" ]] || error "missing tools/gas-preprocessor.pl"
export PATH="$libqk/tools:$PATH"

build_lib() {
  local platform=$1; shift
  local cc_name=$1; shift
  local cc_opt=$1; shift
  local name="$1"; shift
  local config_args="$@"
  eval local path=\$$name
  echo "building $platform $name: $path"
  local d="libs-$platform/$name"
  [[ -d "$d" ]] && rm -rf "$d"
  mkdir -p "$d"
  ./build-lib-$platform.sh $cc_name $cc_opt lib$name "$path" built-$platform/$name $config_args
  echo
}

build_lib mac clang -Oz sqlite3
build_lib ios clang -Oz sqlite3
build_lib mac clang -O3 png
build_lib ios clang -O3 png --enable-arm-neon
build_lib mac clang -O3 turbojpeg --with-jpeg8
build_lib ios gcc -O3 turbojpeg --with-jpeg8 --with-gas-preprocessor # cannot yet compile neon successfully
