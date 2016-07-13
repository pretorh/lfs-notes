/tools/bin/find /{,usr/}{bin,lib,sbin} -type f      \
    -exec /tools/bin/strip --strip-debug '{}' ';'   \
    2>&1 \
    | grep -v "File format not recognized" \
    | grep -v "is not an ordinary file"

rm -rf /tmp/*

rm -f /usr/lib/lib{bfd,opcodes}.a
rm -f /usr/lib/libbz2.a
rm -f /usr/lib/lib{com_err,e2p,ext2fs,ss}.a
rm -f /usr/lib/libltdl.a
rm -f /usr/lib/libfl.a
rm -f /usr/lib/libfl_pic.a
rm -f /usr/lib/libz.a
