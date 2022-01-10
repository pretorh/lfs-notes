#!/usr/bin/env bash

echo "setup testing"
ulimit -s 32768
chown -R tester .

echo "starting tests"
time su tester -c "PATH=$PATH make --jobs 4 -k check || echo 'make check failed'"

echo "failed tests:"
../contrib/test_summary | grep FAIL | sort
echo "# end of FAILed test list"

echo "cleanup permissions"
chown -R root .
