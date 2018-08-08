GAWK_VERSION=4.2.0
mkdir -v $DESTDIR/usr/share/doc/gawk-$GAWK_VERSION
cp    -v doc/{awkforai.txt,*.{eps,pdf,jpg}} $DESTDIR/usr/share/doc/gawk-$GAWK_VERSION
unset GAWK_VERSION
