#!/usr/bin/env sh
set -e

echo "patch tests for Bash 5.2 and later"
sed -e 's/SECONDS|/&SHLVL|/' \
    -e '/BASH_ARGV=/a\ /^SHLVL=/ d' \
    -i.orig tests/local.at
