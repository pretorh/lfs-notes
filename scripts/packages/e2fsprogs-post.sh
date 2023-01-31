#!/usr/bin/env bash
set -e

echo "remove static libs"
rm -fv "$DESTDIR"/usr/lib/lib{com_err,e2p,ext2fs,ss}.a

echo "info dir"
gunzip -v "$DESTDIR"/usr/share/info/libext2fs.info.gz
# update in destdir - need to update in final dir when extracted
install-info --dir-file="$DESTDIR"/usr/share/info/dir /usr/share/info/libext2fs.info
