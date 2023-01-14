#!/usr/bin/env sh

env LC_ALL=C make check --jobs 4 2>&1 | tee make-check.log
if grep failed make-check.log ; then
  exit 1
fi
grep "success rate" make-check.log
