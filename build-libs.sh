#!/usr/bin/env bash
# Copyright 2013 George King.
# Permission to use this file is granted in libqk/license.txt.

# build fat static libs from autoconf/make based source.

set -e

error() { echo 'error:' "$@" 1>&2; exit 1; }

[[ $0 == "./build-libs.sh" ]] || error "must invoke as ./build-libs.sh"

[[ ${#@} == 2 ]] || error "usage: png-path sqlite3-path"

png=$1; shift
sqlite3=$1; shift
libqk="$PWD"

platforms="mac ios"
libs="png sqlite3"

for l in $libs; do
  eval lib_path=\$$l
  echo "building $l: $lib_path"
  for p in $platforms; do
    d="libs-$p/$l"
    [[ -d "$d" ]] && rm -rf "$d"
    mkdir -p "$d"
    ./build-lib-$p.sh lib$l "$lib_path" built-$p/$l
  done
done

