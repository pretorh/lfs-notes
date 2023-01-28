#!/usr/bin/env bash
set -e

chown -R tester .

echo "tests: starting..."
su tester -c "make --jobs 4 -k check | tee check-log"
echo "tests: passed" # todo: need to fail this if there are failing tests

chown -R root .
