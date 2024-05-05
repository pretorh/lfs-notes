#!/usr/bin/env bash

expected_failulres="man1/lexgrog.1"

if make check -k --jobs=4 &>check.log ; then
  echo "check passed!"
else
  echo "check failed"
  if grep -E "^FAIL" check.log | grep -vE "^FAIL: ($expected_failulres)$" ; then
    echo "There are unexpected test failures" >&2
    exit 1
  fi
  echo "but only expected errors"
fi
