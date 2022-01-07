#!/usr/bin/env sh

make NON_ROOT_USERNAME=tester check-root --jobs 4 | tee check-root-log

# add `nobody` user to a dummy group
echo "dummy:x:102:tester" >> /etc/group
chown -R tester .

su tester -c "PATH=$PATH make RUN_EXPENSIVE_TESTS=yes check --jobs 4 | tee check-log"

# remove from dummy group, change permissions
sed -i '/dummy/d' /etc/group
chown -R root .
