chmod -v u+w $DESTDIR/usr/lib/{libcom_err,libe2p,libext2fs,libss}.a

# update info-dir
gunzip -v $DESTDIR/usr/share/info/libext2fs.info.gz
install-info --dir-file=$DESTDIR/usr/share/info/dir $DESTDIR/usr/share/info/libext2fs.info

# additional docs
makeinfo -o      doc/com_err.info ../lib/et/com_err.texinfo
install -v -m644 doc/com_err.info $DESTDIR/usr/share/info
install-info --dir-file=$DESTDIR/usr/share/info/dir $DESTDIR/usr/share/info/com_err.info
