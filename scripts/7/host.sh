#!/usr/bin/env sh

host=${1?pass hostname as first argument}

echo "setting up hostname as $host"
echo "$host" > /etc/hostname

cat > /etc/hosts << EOF
127.0.0.1 localhost
127.0.1.1 $host
::1       localhost
EOF
