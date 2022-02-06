#!/usr/bin/env sh

selected_tz=$(tzselect)
echo "selected $selected_tz"
ln -sfv /usr/share/zoneinfo/"$selected_tz" /etc/localtime
