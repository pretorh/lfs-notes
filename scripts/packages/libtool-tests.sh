#!/usr/bin/env bash

expected_failulres="Link order test|compiling softlinked libltdl|compiling copied libltdl|installable libltdl|linking libltdl without autotools|linking libltdl without autotools|Run tests with low max_cmd_len"

if make check TESTSUITEFLAGS=-j4 &>check.log ; then
  echo "check passed!"
else
  echo "check failed"
  if grep -E "^[0-9]+.*FAILED" tests/testsuite.log | grep -vE "[0-9]+\. ($expected_failulres)" ; then
    echo "There are unexpected test failures" >&2
    exit 1
  fi
  echo "But only expected failures:"
  grep -E "^[0-9]+.*FAILED" tests/testsuite.log
fi
