echo "enter ll (language 2 letter)"
read locale_ll
echo "enter CC (couttry 2 letter)"
read locale_cc

locale_llcc=$(locale -a | grep -i $locale_ll | grep -i $locale_cc | sort | head -n 1)
locale_name=$(locale -a | grep $locale_llcc | grep utf8)
echo "selected $locale_name for $locale_llcc"

locale_charmap=$(LC_ALL=$locale_name locale charmap)
echo "found charmap: $locale_charmap"

locale_final="${locale_llcc}.${locale_charmap}"
echo "locale string: $locale_final"

echo "testing..."
LC_ALL=$locale_final locale language
LC_ALL=$locale_final locale charmap
LC_ALL=$locale_final locale int_curr_symbol
LC_ALL=$locale_final locale int_prefix

echo "setting"
echo "$locale_final" > /etc/locale.conf
cat /etc/locale.conf


unset locale_ll
unset locale_cc
unset locale_llcc
unset locale_name
unset locale_charmap
unset locale_final
