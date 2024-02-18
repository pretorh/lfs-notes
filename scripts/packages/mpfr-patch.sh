#!/usr/bin/env sh
set -e

sed -e 's/+01,234,567/+1,234,567 /' \
  -e 's/13.10Pd/13Pd/' \
  -i tests/tsprintf.c
