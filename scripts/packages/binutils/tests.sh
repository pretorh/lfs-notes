#!/usr/bin/env bash

expected_failulres=""

if make -k check --jobs "$(nproc)" &>check.log ; then
  echo "check passed!"
else
  echo "check failed"
  if grep -E "^FAIL" check.log | grep -vE "^FAIL: ($expected_failulres)$" ; then
    exit 1
  fi
  echo "But only expected failures:"
  grep -E "^FAIL" check.log
fi
