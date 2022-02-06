#!/usr/bin/env bash

echo "enable shadowed passwords"
pwconv
grpconv
echo ""

echo "user defaults"
# todo: need to change the 'users' group id from setup as well
useradd -D --gid 999
sed -i /etc/default/useradd -e 's/CREATE_MAIL_SPOOL=yes/CREATE_MAIL_SPOOL=no/'
useradd -D
echo ""

echo "set root user password"
passwd root
