#!/usr/bin/env bash

ROOT=${1-.}
echo "stipping relative to $ROOT"

ignore_warnings() {
	grep -iv \
        -e "file format not recognized" \
        -e "is not an ordinary file" \
        -
}

# todo: this ignores runnings binaries/used libs
while IFS= read -r -d '' file
do
  strip --strip-unneeded "$file" 2>&1 | ignore_warnings
done <   <(find "$ROOT"/usr/lib -type f -name '*.so*' ! -name '*dbg' -print0
           find "$ROOT"/usr/lib -type f -name '*.a' -print0
           find "$ROOT"/usr/{bin,sbin,libexec} -type f -print0)
