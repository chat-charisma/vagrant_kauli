#
# auth
#
cp /kauli/auth/development/service/nginx/auth.conf /etc/nginx/conf.d/
cp /kauli/auth/development/config.yaml /kauli/auth/config_local.yaml

if ! grep -q "dev-api.kau.li" /etc/hosts; then
    cat >> /etc/hosts << EOF
127.0.0.1 dev-api.kau.li
EOF
fi

#
# kamikaze
#
cp -r /kauli/kamikaze/development/service/nginx/* /etc/nginx/conf.d/
sed "s/^lert_slack_channel/a&/" /kauli/kamikaze/development/config.yaml > /kauli/kamikaze/config_local.yaml

cat > /etc/nginx/conf.d/dspui.conf << EOF
server {
    listen 80;
    server_name dev-dr.kau.li;
    access_log  /var/log/nginx/dspui.log  main;

    location /report {
        alias /kauli/kamikaze_ui/report/app;
    }

    location /operator {
        alias /kauli/kamikaze_ui/operator/app;
    }

    location / {
        root /kauli/kamikaze_ui;
    }

    location ~ /(?:operator|report)/kauli/js/config.js {
        alias /kauli/kamikaze_ui/kauli/js/config.js;
        sub_filter https://api.kau.li/ http://dev-api.kau.li/;
        sub_filter_once off;
        sub_filter_types application/javascript;
    }
}
EOF

mkdir -p /kauli/logs/dsp/mcv

#
# auth, kamikaze
#
service nginx restart
ln -fs /kauli/auth/service/upstart/kauli_auth_api.conf /kauli/kamikaze/service/upstart/kauli_dsp_api.conf /etc/init/
initctl reload-configuration
service start-kauli start