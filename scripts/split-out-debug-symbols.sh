#!/usr/bin/env bash
set -e

file=${1?need the file to split debug symbols for}

for file in "$@" ; do
    if [ -f "$file.dbg" ] ; then
        echo "$file.dbg already exists"
        continue
    fi

    pre_size="$(du -h "$file" | cut -f1)"
    objcopy --only-keep-debug "$file" "$file.dbg"
    strip --strip-unneeded "$file"
    objcopy --add-gnu-debuglink="$file.dbg" "$file"
    echo "split $file ($pre_size) into $file ($(du -h "$file" | cut -f1)) and $file.dbg ($(du -h "$file.dbg" | cut -f1))"
done
