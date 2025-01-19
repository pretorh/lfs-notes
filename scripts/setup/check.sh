#!/usr/bin/env sh

echo "sh should be Bash"
echo "/bin/sh -> $(readlink -f /bin/sh)"

echo "yacc should be Bison"
if [ -h /usr/bin/yacc ] ; then
    echo "/usr/bin/yacc -> $(readlink -f /usr/bin/yacc)";
    echo "  which is $(/usr/bin/yacc --version | head -n1)"
elif [ -x /usr/bin/yacc ] ; then
    echo "yacc is $(/usr/bin/yacc --version | head -n1)"
else
    echo "yacc not found"
fi

echo "awk should be GNU Awk"
if [ -h /usr/bin/awk ]; then
    echo "/usr/bin/awk -> $(readlink -f /usr/bin/awk)";
    echo "  which is $(/usr/bin/awk --version | head -n1)"
elif [ -x /usr/bin/awk ]; then
    echo "awk is $(/usr/bin/awk --version | head -n1)"
else
    echo "awk not found"
fi

g++ --version | head -n1
echo 'int main(){}' > dummy.c && g++ -o dummy dummy.c
if [ -x dummy ] ; then
    echo "  compilation OK";
else
    echo "  compilation failed"
fi
rm -f dummy.c dummy
