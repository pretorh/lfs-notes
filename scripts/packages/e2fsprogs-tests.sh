#!/usr/bin/env bash

expected_failulres="m_assume_storage_prezeroed"

if make check -k --jobs=4 &>check.log ; then
  echo "check passed!"
else
  echo "check failed"
  if grep -E "failed$" check.log | grep -vE "^.*tests succeeded.*tests failed$" | grep -vE "^($expected_failulres): .*: failed$" ; then
    echo "There are unexpected test failures" >&2
    exit 1
  fi
  echo "But only expected failures:"
  grep -E "failed$" check.log
fi
