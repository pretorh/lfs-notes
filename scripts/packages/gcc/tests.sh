#!/usr/bin/env bash

echo "setup testing"
ulimit -s 32768
chown -R tester .

echo "starting tests"
time su tester -c "PATH=$PATH make --jobs 8 -k check || echo 'make check failed'"

echo "failed tests:"
../contrib/test_summary | grep -E '(XPASS|FAIL)' | sort | tee failed-test-summary.log
echo "# end of FAILed test list"

if grep -v "c-c++-common/goacc/kernels-decompose-pr100400-1-2.c" failed-test-summary.log >/dev/null ; then
  echo "FAIL: there are unexpected failing tests" >&2
  exit 1
else
  echo "only expected failing tests, will continue"
fi

echo "cleanup permissions"
chown -R root .
