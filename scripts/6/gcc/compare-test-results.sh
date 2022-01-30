#!/usr/bin/env sh

# get failures, filter out known failures and sort the final results
../contrib/test_summary | grep FAIL \
    | grep -v get_time \
    | grep -v asan_test.C \
    | grep -v '/analyzer/' \
    | grep -v '/49745.cc ' \
    | grep -v '/numpunct/' \
    | sort
