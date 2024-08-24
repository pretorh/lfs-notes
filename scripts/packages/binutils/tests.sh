#!/usr/bin/env bash

expected_failulres="weak_undef_test|initpri3a|script_test_1|script_test_2|justsyms|justsyms_exec|binary_test|script_test_3|tls_phdrs_script_test|script_test_12i|incremental_test_2|incremental_test_5|tmpdir/gp-archive|tmpdir/gp-collect-app_F|tmpdir/setpath_map"

if make -k check --jobs 4 &>check.log ; then
  echo "check passed!"
else
  echo "check failed"
  if grep -E "^FAIL" check.log | grep -vE "^FAIL: ($expected_failulres)$" ; then
    exit 1
  fi
  echo "But only expected failures:"
  grep -E "^FAIL" check.log
fi
