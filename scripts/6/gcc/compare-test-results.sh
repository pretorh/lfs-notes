#!/usr/bin/env sh

# get failures, filter out known failures and sort the final results
../contrib/test_summary | grep FAIL \
    | grep -v get_time \
    | grep -v -e asan_test.C -e co-ret-17-void-ret-coro.C -e pr95519-05-gro.C -e pr80166.c \
    | sort
