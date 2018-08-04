make NON_ROOT_USERNAME=nobody check-root

# add `nobody` user to a dummy group
echo "dummy:x:1000:nobody" >> /etc/group
chown -Rv nobody .


su nobody -s /bin/bash \
          -c "PATH=$PATH make RUN_EXPENSIVE_TESTS=yes check"

# remove from dummy group
sed -i '/dummy/d' /etc/group
