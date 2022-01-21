#!/usr/bin/env bash

sed -e 's/__attribute_nonnull__/__nonnull/' \
  -i gnulib/lib/malloc/dynarray-skeleton.c
