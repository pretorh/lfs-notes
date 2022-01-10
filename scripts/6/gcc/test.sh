#!/usr/bin/env bash

echo "setup testing"
ulimit -s 32768
chown -Rv tester .

echo "starting tests"
time su tester -c "PATH=$PATH make --jobs 4 -k check || echo 'make check failed'"

echo "summary"
../contrib/test_summary | grep -A7 Summ

echo "cleanup permissions"
chown -Rv root .
