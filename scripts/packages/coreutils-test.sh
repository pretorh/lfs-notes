#!/usr/bin/env sh

make NON_ROOT_USERNAME=tester check-root --jobs 4 | tee check-root-log

groupadd -g 102 dummy -U tester
chown -R tester .

su tester -c "PATH=$PATH make RUN_EXPENSIVE_TESTS=yes check --jobs 4 | tee check-log"

# remove from dummy group, change permissions
groupdel dummy
chown -R root .
