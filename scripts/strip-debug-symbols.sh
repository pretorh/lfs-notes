#!/usr/bin/env bash

ROOT=${1-.}
echo "stipping relative to $ROOT"

ignore_warnings() {
	grep -iv \
        -e "file format not recognized" \
        -e "is not an ordinary file" \
        -
}

echo "debug in: usr/lib"
while IFS= read -r -d '' file
do
    strip --strip-debug "$file" 2>&1 | ignore_warnings
done <   <(find "$ROOT"/usr/lib -type f -name '*.a' -print0)

echo "unneeded in: lib usr/lib"
while IFS= read -r -d '' file
do
    strip --strip-unneeded "$file" 2>&1 | ignore_warnings
done <   <(find "$ROOT"/lib "$ROOT"/usr/lib -type f -name '*.so*' ! -name '*dbg' -print0)

echo "all in: bin, sbin, usr/bin, usr/sbin, usr/libexec"
while IFS= read -r -d '' file
do
    strip --strip-all "$file" 2>&1 | ignore_warnings
done <   <(find "$ROOT"/{bin,sbin} "$ROOT"/usr/{bin,sbin,libexec} -type f -print0)
