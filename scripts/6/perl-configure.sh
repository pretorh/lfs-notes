#!/usr/bin/env bash
set -e

# extract major+minor version number, based on https://stackoverflow.com/a/22261643/1016377
dirname="$(basename "$(pwd)")"
[[ $dirname =~ perl-([0-9]+)\.([0-9]+) ]] && \
  version_major_minor="${BASH_REMATCH[1]}.${BASH_REMATCH[2]}" || version_major_minor=5
echo "configuring perl $version_major_minor (in $dirname)"

sh Configure -des \
  -Dprefix=/usr \
  -Dvendorprefix=/usr \
  -Dprivlib="/usr/lib/perl5/$version_major_minor/core_perl" \
  -Darchlib="/usr/lib/perl5/$version_major_minor/core_perl" \
  -Dsitelib="/usr/lib/perl5/$version_major_minor/site_perl" \
  -Dsitearch="/usr/lib/perl5/$version_major_minor/site_perl" \
  -Dvendorlib="/usr/lib/perl5/$version_major_minor/vendor_perl" \
  -Dvendorarch="/usr/lib/perl5/$version_major_minor/vendor_perl"
