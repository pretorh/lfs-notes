set -e

perl Makefile.PL
make --jobs=8
make test --jobs=8
make install DESTDIR=$DESTDIR
