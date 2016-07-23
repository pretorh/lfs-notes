echo "dummy:x:1000:nobody" >> /etc/group
chown -Rv nobody .
su nobody -s /bin/bash \
          -c "PATH=$PATH make RUN_EXPENSIVE_TESTS=yes check"
sed -i '/dummy/d' /etc/group
