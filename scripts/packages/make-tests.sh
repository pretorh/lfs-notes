#!/usr/bin/env bash
set -e

chown -R tester .
su tester -c "PATH=$PATH make check"
chown -R root .
