. /vagrant/conf.sh

slash_domain=`echo $domain | sed 's/\./\\\\\\\./g'`
sed "s/kau.li/$domain/;s/kau\\\.li/$slash_domain/;s/deny all/# &/" /kauli/dmp/service/dmp_api_nginx.conf > /etc/nginx/conf.d/dmp_api_nginx.conf
sed "s/kau.li/$domain/;s/deny all/# &/;s/aj1003.j13/localhost/" /kauli/dmp/service/dmp_nginx.conf > /etc/nginx/conf.d/dmp_nginx.conf
sudo service nginx restart

cat > /kauli/dmp/config_local.yaml << EOF
databases:
    main:
        master:
            dsn:      dbi:mysql:dev_kauli_main_db:localhost
            username: user
            password: fz
        slave:
            dsn:      dbi:mysql:dev_kauli_main_db:localhost
            username: readonly
            password: fz
    yop:
        master:
            dsn:      dbi:mysql:dev_kauli_yop_db:localhost
            username: user
            password: fz
        slave:
            dsn:      dbi:mysql:dev_kauli_yop_db:localhost
            username: readonly
            password: fz
    yop_log:
        master:
            dsn:      dbi:mysql:dev_kauli_yop_log_db:localhost
            username: user
            password: fz
        slave:
            dsn:      dbi:mysql:dev_kauli_yop_log_db:localhost
            username: readonly
            password: fz
    dmp:
        master:
            dsn:      dbi:mysql:dev_kauli_dmp:localhost
            username: user
            password: fz
        slave:
            dsn:      dbi:mysql:dev_kauli_dmp:localhost
            username: readonly
            password: fz
    dmp_admin:
        master:
            dsn:      dbi:mysql:dev_kauli_dmp:localhost
            username: admin
            password: DUqP7m9FBvaep6n8

redis:
    website:
        host: localhost
        port: 6379
        db: 2
    counter:
        host: localhost
        port: 6379
        db: 3
    inventory:
        host: localhost
        port: 6379
        db: 4
    unique_counter:
        host: localhost
        port: 6379
        db: 0

alert_email:
    mail_from: $mail
    debug: $mail
    notice: $mail
    info: $mail
    warn: $mail
    crit: $mail

debug_allowed_ips:
    - 127.0.0.1
    - 172.28.128.1

alert_slack_channel: '#test'
EOF

mkdir -p -m 777 /tmp/ssp/spot
mkdir -p /kauli/logs/dmp/api

ln -fs /kauli/dmp/service/kauli_dmp_api_upstart.conf /kauli/dmp/service/kauli_dmp_dashboard_upstart.conf /etc/init/
initctl reload-configuration
service kauli_dmp_api_upstart restart
service kauli_dmp_dashboard_upstart restart
