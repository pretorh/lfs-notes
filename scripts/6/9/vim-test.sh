#!/usr/bin/env bash
set -e

chown -R tester .
echo "running tests (redirected output)"
su tester -c "LANG=en_US.UTF-8 make -j1 test" &> vim-test.log
grep "ALL DONE" vim-test.log || (echo "ERROR: tests failed, check vim-test.log" && false)

chown -R root .
