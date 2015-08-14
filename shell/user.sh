. /vagrant/conf.sh

apt-get install -y php5 php5-cli php5-memcache php5-mysql php5-mcrypt php5-curl php5-fpm

sed -i "s/error_reporting = E_ALL & \~E_DEPRECATED$/& \& ~E_NOTICE/;s/memory_limit = 128M/memory_limit = 256M/;s/short_open_tag = Off/short_open_tag = On/" /etc/php5/fpm/php.ini

sed "s/XXXXX.ubuntu.dev.kau.li/local.kau.li/;s/kauli\/kauli\/user/kauli\/user/" /kauli/user/service/develop/sspui_nginx.conf > /etc/nginx/conf.d/sspui_nginx.conf
sed "s/XXXXX.ubuntu.dev.kau.li/local.kau.li/;s/kauli\/kauli\/user/kauli\/user/" /kauli/user/service/develop/sspui_env_nginx.conf > /etc/nginx/conf.d/sspui_env_nginx.conf

sed "s/ui.ssp.kau.li.socket/&\nlisten.owner = nginx\nlisten.group = nginx\nlisten.mode = 0660/" /kauli/user/service/develop/sspui_fpm.conf > /etc/php5/fpm/pool.d/sspui_fpm.conf

chmod -R 777 /kauli/user/app/tmp

service nginx restart
service php5-fpm restart

sed "s/dbmaster/localhost/;s/kauli/dev_&/" /kauli/user/app/config/database_production.php > /kauli/user/app/config/database_develop.php

cat > /kauli/user/app/config/develop.php << EOF
<?php
Configure::write('debug', 1);
Configure::write('Config.language', 'ja');
Configure::write('Kauli.email_from', '$mail');
Configure::write('Kauli.email_bcc', '$mail');
Configure::write('Kauli.email_inquiry_to_admin', '$mail');
Configure::write('Kauli.exception_mail_from', '$mail');
Configure::write('Kauli.exception_mail_to', '$mail');
Configure::write('Kauli.exception_mail_to_by_notice', '$mail');
Configure::write('Kauli.exception_mail_to_by_warning', '$mail');
Configure::write('Kauli.banner_aws_bucket', 'kaulidevbanner');
Configure::write('Kauli.banner_aws_s3_domain',  'kaulidevbanner.s3.amazonaws.com');
Configure::write('Kauli.banner_aws_cdn_domain', 'd1vth35ljrdpd3.cloudfront.net');
Configure::write('Kauli.yopad_aws_bucket', 'kaulidevyopad');
Configure::write('Kauli.yopad_aws_s3_domain', 'kaulidevyopad.s3.amazonaws.com');
EOF

chmod -R 777 /kauli/user/app/tmp

cat > /kauli/user/app/config/vendor_develop.php << EOF
<?php

class VendorConfig
{
    static \$exuiBaseURL = 'https://exui.$domain/internal';
    static \$exuiTokenPrefix = 'exui::internal::token::';
    static \$exuiLogFormat = '[Kauli Internal Exui] %s';
    static \$agencyBaseURL = 'https://agency.$domain/internal';
    static \$agencyTokenPrefix = 'exui::internal::token::';  // common to exui
    static \$agencyLogFormat = '[Kauli Internal Agency] %s';
    static \$adsenseApiURL = 'http://api.$domain:8080/ssp/api/adsense/v4';
    static \$userApiURL = 'http://ci.ubuntu.dev.kau.li:8080/?test=';
    static \$dmpApiURL = 'http://dmp-api.$domain/api';
}
EOF
