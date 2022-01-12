#!/usr/bin/env sh

# major.minor version only
PERL_VERSION=5.34

# use system libs
export BUILD_ZLIB=False
export BUILD_BZIP2=0

sh Configure -des -Dprefix=/usr                 \
                  -Dvendorprefix=/usr           \
                  -Dprivlib=/usr/lib/perl5/$PERL_VERSION/core_perl       \
                  -Darchlib=/usr/lib/perl5/$PERL_VERSION/core_perl       \
                  -Dsitelib=/usr/lib/perl5/$PERL_VERSION/site_perl       \
                  -Dsitearch=/usr/lib/perl5/$PERL_VERSION/site_perl      \
                  -Dvendorlib=/usr/lib/perl5/$PERL_VERSION/vendor_perl   \
                  -Dvendorarch=/usr/lib/perl5/$PERL_VERSION/vendor_perl  \
                  -Dman1dir=/usr/share/man/man1 \
                  -Dman3dir=/usr/share/man/man3 \
                  -Dpager="/usr/bin/less -isR"  \
                  -Duseshrplib                  \
                  -Dusethreads
