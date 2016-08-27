# strip
/tools/bin/find /{,usr/}{bin,lib,sbin} -type f      \
    -exec /tools/bin/strip --strip-debug '{}' ';'   \
    2>&1 \
    | grep -v "File format not recognized" \
    | grep -v "is not an ordinary file"
