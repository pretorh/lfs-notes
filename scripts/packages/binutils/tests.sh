#!/usr/bin/env bash

if make -k check --jobs 1 &>check.log ; then
  echo "check passed!"
else
  echo "check failed"
  if grep -E "^FAIL" check.log ; then
    exit 1
  fi
  if grep -E "^ERROR" check.log | grep -vE "^ERROR: (compilation of test program in jsynprog|comparison of results in mttest) failed$" ; then
    exit 1
  fi
  echo "but only expected errors"
fi
