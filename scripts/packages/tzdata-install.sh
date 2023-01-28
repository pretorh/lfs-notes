#!/usr/bin/env bash
set -e

tz_data=$(mktemp -d ./tzdata-XXXXX)
cd "$tz_data"

tar -xf ../tzdata*.tar.gz

ZONEINFO=$DESTDIR/usr/share/zoneinfo
mkdir -pv "$ZONEINFO"/{posix,right}

for tz in etcetera southamerica northamerica europe africa antarctica  \
          asia australasia backward; do
    zic -L /dev/null    -d "$ZONEINFO"        ${tz}
    zic -L /dev/null    -d "$ZONEINFO/posix"  ${tz}
    zic -L leapseconds  -d "$ZONEINFO/right"  ${tz}
done

cp -v zone.tab zone1970.tab iso3166.tab "$ZONEINFO"
# "We use New York because POSIX requires the daylight savings time rules to be in accordance with US rule"
zic -d "$ZONEINFO" -p America/New_York

cd ..
rm -rf "$tz_data"
