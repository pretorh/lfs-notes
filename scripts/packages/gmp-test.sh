#!/usr/bin/env bash
set -e
set -o pipefail

if make --jobs 4 check &> gmp-check-log ; then
  echo "make check passed"
else
  echo "tests failed!" >&2
fi

passed=$(awk '/# PASS:/{total+=$3} ; END{print total}' gmp-check-log)
echo "$passed"
test "$passed" -ge 199
