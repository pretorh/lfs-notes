echo "quit" | ./bc/bc -l Test/checklib.b > bc-test-log

echo "failures:"
cat bc-test-log | grep "Total failures: [^0]"

echo 'for more details: cat bc-test-log | grep -e "index\|val1\|val2"'
