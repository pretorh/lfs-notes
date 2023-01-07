#!/usr/bin/env sh

echo "create global pip.conf"
cat > /etc/pip.conf << EOF
[global]
root-user-action = ignore
disable-pip-version-check = true
EOF
