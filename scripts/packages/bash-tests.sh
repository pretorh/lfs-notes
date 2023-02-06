#!/usr/bin/env bash
# shellcheck disable=SC2154

chown -R tester .

time su -s /usr/bin/expect tester << EOF
set timeout -1
spawn make tests --jobs 4
expect eof
lassign [wait] _ _ _ value
exit $value
EOF

chown -R root .
