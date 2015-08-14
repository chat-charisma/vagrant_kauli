#
# common
#
ln -fs config_test.yaml /kauli/common/config_local.yaml

sed -i "s:exec /usr/sbin/mysqld$:& --skip-grant-tables:" /etc/init/mysql.conf
if ! grep -q "default-time-zone" /etc/mysql/my.cnf; then
    sed -i "s/\[mysqld\]/&\ndefault-time-zone = '-00:00'\ncharacter-set-server = utf8\nmax_connections = 2048/" /etc/mysql/my.cnf
fi
service mysql restart

addgroup kauli1129

cat > /etc/init/start-kauli.conf << EOF
start on vagrant-mounted

script
    initctl list | grep ^kauli_ | awk '{print \$1}' | xargs -I{} service {} restart
end script
EOF