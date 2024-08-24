#!/usr/bin/env sh

unexpected_failures() {
  grep '^FAIL' tests.sum \
    | grep -v 'misc/tst-preadvwritev2' \
    | grep -v 'misc/tst-preadvwritev64v2' \
    | grep -v 'io/tst-lchmod'
}

if make check --jobs 4 ; then
  echo "Tests passed"
elif unexpected_failures ; then
  echo "Unknown failures!" 2>&1
  exit 1
else
  grep '^FAIL' tests.sum
  echo "Known failures only"
fi
