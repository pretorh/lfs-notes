strip --strip-debug /tools/lib/* 2>&1 | grep -v "File format not recognized" | grep -v "is not an ordinary file"
/usr/bin/strip --strip-unneeded /tools/{,s}bin/* 2>&1 | grep -v "File format not recognized" | grep -v "is not an ordinary file"

rm -rf /tools/{,share}/{info,man,doc}
