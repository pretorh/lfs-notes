du -sb /tools/

strip --strip-debug /tools/lib/* 2>&1 \
	| grep -v "File format not recognized" \
	| grep -v "is not an ordinary file" \
	| grep -v "is a directory"
/usr/bin/strip --strip-unneeded /tools/{,s}bin/* 2>&1 \
	| grep -v "File format not recognized" \
	| grep -v "is not an ordinary file" \
	| grep -v "is a directory"
rm -rf /tools/{,share}/{info,man,doc}
find /tools/{lib,libexec} -name \*.la -delete

du -sb /tools/

chown -R root:root $LFS/tools
