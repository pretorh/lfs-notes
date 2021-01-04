#!/bin/bash

echo "/bin/sh -> $(readlink -f /bin/sh)"

if [ -h /usr/bin/yacc ] ; then
    echo "/usr/bin/yacc -> $(readlink -f /usr/bin/yacc)";
elif [ -x /usr/bin/yacc ] ; then
    echo "yacc is $(/usr/bin/yacc --version | head -n1)"
else
    echo "yacc not found"
fi

if [ -h /usr/bin/awk ]; then
    echo "/usr/bin/awk -> $(readlink -f /usr/bin/awk)";
elif [ -x /usr/bin/awk ]; then
    echo "awk is $(/usr/bin/awk --version | head -n1)"
else
    echo "awk not found"
fi

echo 'int main(){}' > dummy.c && g++ -o dummy dummy.c
if [ -x dummy ] ; then
    echo "g++ compilation OK";
else
    echo "g++ compilation failed"
fi
rm -f dummy.c dummy
