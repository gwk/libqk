#!/usr/bin/env bash
# Copyright 2013 George King.
# Permission to use this file is granted in libqk/license.txt.

# build fat static libs from autoconf/make based source.

set -e

error() { echo 'error:' "$@" 1>&2; exit 1; }

[[ $0 == "./build-libs.sh" ]] || error "must invoke as ./build-libs.sh"

[[ ${#@} == 4 ]] || error "usage: std-out sqlite3 png jpeg-turbo"

libqk="$PWD"

platforms="mac ios"

# libjpeg-turbo requires gas-preprocessor, obtained from https://github.com/yuvi/gas-preprocessor
[[ -r "$libqk/tools/gas-preprocessor.pl" ]] || error "missing tools/gas-preprocessor.pl"
#export PATH="$libqk/tools:$PATH"

build_lib() {
  local path="$1"; shift
  local name="$1"; shift
  local cc_name_mac="$1"; shift
  local cc_name_ios="$1"; shift
  local config_args="$@"
  echo "building $name: $path"
  for p in $platforms; do
    eval local cc_name=\$cc_name_$p
    local d="libs-$p/$name"
    [[ -d "$d" ]] && rm -rf "$d"
    mkdir -p "$d"
    ./build-lib-$p.sh "$path" lib$name $cc_name built-$p/$name $config_args
    echo
  done
  echo
}

export OUT="$1"
shift
echo "redirecting build output to $OUT..."
[[ -w "$OUT" ]] || "bad output file: $OUT"

#build_lib "$1" sqlite3 clang clang
shift
#build_lib "$1" png clang clang
shift
build_lib "$1" turbojpeg clang gcc --with-jpeg8 --with-gas-preprocessor
shift
