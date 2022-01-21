#!/usr/bin/env bash

sed -e '/NOTIFY_REMOVED)/s/)/ \&\& data.attr != NULL)/' \
  -i sysdeps/unix/sysv/linux/mq_notify.c
