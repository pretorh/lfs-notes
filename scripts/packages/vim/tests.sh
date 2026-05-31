#!/usr/bin/env bash
set -e

chown -R tester .
echo "skipping certain tests"
sed '/test_plugin_glvs/d' -i src/testdir/Make_all.mak

echo "running tests (redirected output)"
su tester -c "TERM=xterm-256color LANG=en_US.UTF-8 make -j1 test" &> vim-test.log || (echo "ERROR: vim tests failed" && false)
grep "ALL DONE" vim-test.log || (echo "ERROR: tests failed, check vim-test.log" && false)

chown -R root .
