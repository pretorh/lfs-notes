#!/usr/bin/env bash

expected_failulres="capabilities: binary store/restore"

if make check -k --jobs=4 &>check.log ; then
  echo "check passed!"
else
  echo "check failed"
  if grep -E "^[0-9]+\. .* FAILED" tests/testsuite.log | grep -vE "($expected_failulres) .* FAILED" ; then
    echo "There are unexpected test failures" >&2
    exit 1
  fi
  echo "But only expected failures:"
  grep -E "^[0-9]+\. .* FAILED" tests/testsuite.log
fi
