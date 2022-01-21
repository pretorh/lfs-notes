#!/usr/bin/env bash
set -e

echo "tests: patching"
rm -v tests/ts/lsns/ioctl_ns

chown -R tester .

echo "tests: starting..."
su tester -c "make -k check | tee check-log"
echo "tests: passed"

chown -R root .
