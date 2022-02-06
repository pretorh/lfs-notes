#!/usr/bin/env bash
set -e

echo -n "enter ll (language 2 letter): "
read -r locale_ll
echo -n "enter CC (coutry 2 letter): "
read -r locale_cc

locale_llcc=$(locale -a | grep -i "$locale_ll" | grep -i "$locale_cc" | sort | head -n 1 | awk -F . '{print $1}')
locale_name=$(locale -a | grep "$locale_llcc" | grep utf8)
echo "selected $locale_name for $locale_llcc"

locale_charmap=$(LC_ALL=$locale_name locale charmap)
echo "found charmap: $locale_charmap"

locale_final="${locale_llcc}.${locale_charmap}"
echo "locale string: $locale_final"

echo "testing..."
echo "language          : $(LC_ALL=$locale_final locale language)"
echo "charmap           : $(LC_ALL=$locale_final locale charmap)"
echo "currency          : $(LC_ALL=$locale_final locale int_curr_symbol)"
echo "intl phone prefix : $(LC_ALL=$locale_final locale int_prefix)"
echo ""

echo "to persist:"
echo "  echo 'LANG=$locale_final' > /etc/locale.conf"
