. /vagrant/conf.sh

sed "s/kau.li/$domain/g;s/deny all/# &/" /kauli/sysop/service/sysop_nginx.conf > /etc/nginx/conf.d/sysop_nginx.conf
sudo service nginx restart

cat > /kauli/sysop/config_local.yaml << EOF
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
    log:
        master:
            dsn:      dbi:mysql:dev_kauli_log_db:localhost
            username: user
            password: fz
        slave:
            dsn:      dbi:mysql:dev_kauli_log_db:localhost
            username: readonly
            password: fz
    click:
        master:
            dsn:      dbi:mysql:dev_kauli_click_db:localhost
            username: user
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
    sysop:
        master:
            dsn:      dbi:mysql:dev_kauli_sysop:localhost
            username: user
            password: fz

redis:
    ssp_index:
        host: localhost
        port: 6379
        db: 3
    sysop_s3_logs:
        host: localhost
        port: 6379
        db: 9
    sysop_index:
        host: localhost
        port: 6379
        db: 11
    adsense_whitelist_master:
        host: localhost
        port: 6379
        db: 12
    adsense_whitelist_slave:
        host: localhost
        port: 6379
        db: 12

alert_email:
    mail_from: $mail
    debug: $mail
    notice: $mail
    info: $mail
    warn: $mail
    crit: $mail
    bid_rate: $mail
    cookie_sync_status: $mail

notify_spot_revenue_daily:
    mail_to: $mail

slack:
    bid_rate: '#test'
    cookie_sync_status: '#test'

debug_allowed_ips:
    - 127.0.0.1
    - '10.'
    - 202.221.41.135
    - 172.28.128.1

sales_persons:
    - 1234

alert_slack_channel: '#test'
EOF

ln -fs /kauli/sysop/service/kauli_sysop_upstart.conf /etc/init/
initctl reload-configuration
service kauli_sysop_upstart restart
