#!/usr/bin/env bash

version_major_minor=5.34

sh Configure -des \
  -Dprefix=/usr \
  -Dvendorprefix=/usr \
  -Dprivlib="/usr/lib/perl5/$version_major_minor/core_perl" \
  -Darchlib="/usr/lib/perl5/$version_major_minor/core_perl" \
  -Dsitelib="/usr/lib/perl5/$version_major_minor/site_perl" \
  -Dsitearch="/usr/lib/perl5/$version_major_minor/site_perl" \
  -Dvendorlib="/usr/lib/perl5/$version_major_minor/vendor_perl" \
  -Dvendorarch="/usr/lib/perl5/$version_major_minor/vendor_perl"
