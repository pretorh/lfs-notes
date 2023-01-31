#!/usr/bin/env sh

# patch for perl 5.22 and later
sed -i 's:\\\${:\\\$\\{:' intltool-update.in
