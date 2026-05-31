#!/usr/bin/env sh

make NON_ROOT_USERNAME=tester check-root --jobs "$(nproc)" | tee check-root-log

groupadd -g 102 dummy -U tester
chown -R tester .

su tester -c "PATH=$PATH make -k RUN_EXPENSIVE_TESTS=yes check --jobs $(nproc) < /dev/null | tee check-log"

# remove from dummy group, change permissions
groupdel dummy
chown -R root .
