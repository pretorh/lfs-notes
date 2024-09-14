#!/usr/bin/env bash
set -e

chown -R tester .

echo "tests: starting..."
su tester -c "make --jobs 4 -k check | tee check-log"
if grep -E 'All [0-9]+ tests PASSED' check-log ; then
  echo "tests: passed"
else
  echo "tests: failures!" >&2
  exit 1
fi

chown -R root .
