. /vagrant/conf.sh

sed "s/kau.li/local.kau.li/;s#kauli/kauli/exui#kauli/exui#" /kauli/exui/service/exui_nginx.conf > /etc/nginx/conf.d/exui_nginx.conf
sudo service nginx restart

sed -i "s/return \[VENDOR_ID_KAULI, VENDOR_ID_FOUT\]/return [VENDOR_ID_KAULI]/" /kauli/exui/lib/kauli/exui/operations/__init__.py

ln -fs /kauli/ssp/config.yaml /kauli/exui/config.yaml
ln -fs /kauli/ssp/config_local.yaml /kauli/exui/config_local.yaml

mkdir -p /kauli/logs/exui/web

cat > /etc/init/kauli_exui_upstart.conf << EOF
description "exui ui"
author      "info@kau.li"

setuid kauli1129
kill signal INT

script
   export KAULI_HOME=/kauli/exui
   . /kauli/common/python27/bin/activate
   uwsgi \
   --master \
   --socket :3000 \
   --stats :3001 \
   --processes 8 \
   --max-requests 40000 \
   --log-master \
   --disable-logging \
   --wsgi-file /kauli/exui/bin/run_exui.py
end script

respawn
EOF
initctl reload-configuration
service kauli_exui_upstart restart
