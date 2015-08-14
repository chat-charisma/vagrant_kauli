. /vagrant/conf.sh

# MySQLのリセット
cd /kauli/sql/kauli
sh init_testdb.sh
sh initdb.sh

cd /kauli/dmp/sql
sh initdb.sh

mysqladmin drop -f dev_kauli_auth
mysqladmin create dev_kauli_auth
mysql dev_kauli_auth < /kauli/auth/sql/schema.sql

cd /kauli/kamikaze/sql
sh initdb.sh

# 月別テーブルを作成
for i in {0..23}; do
    yyyymm=$(date -d "`date '+%Y/%m/01'` $i month" +%Y%m)
    mysql dev_kauli_log_db -e "CREATE TABLE pva_${yyyymm}_tbl LIKE pva_monthly_tbl"
    mysql dev_kauli_log_db -e "CREATE TABLE pvb_${yyyymm}_tbl LIKE pvb_monthly_tbl"
    mysql dev_kauli_log_db -e "CREATE TABLE pvp_${yyyymm}_tbl LIKE pvp_monthly_tbl"
done

# MySQLへデータを挿入
mysql dev_kauli_yop_db < /vagrant/etc/fc.sql

mysql dev_kauli_yop_db -e "
INSERT INTO exchanges (
    name,
    mail,
    password
)
VALUES (
    'gmoap',
    '`echo $mail | sed s/@/+gmoap@/`',
    '8751c23ea1c3c82256e18d81b67ef431c01a37ab'
), (
    'spider',
    '`echo $mail | sed s/@/+spider@/`',
    '8751c23ea1c3c82256e18d81b67ef431c01a37ab'
), (
    'kauli',
    '`echo $mail | sed s/@/+kauli@/`',
    '8751c23ea1c3c82256e18d81b67ef431c01a37ab'
);"

mysql dev_kauli_main_db -e "
INSERT INTO user_tbl (
    u_mail,
    u_password,
    u_name,
    u_kana,
    u_payment_type,
    u_credit,
    u_main,
    u_admin
)
VALUES (
    '$mail',
    '8751c23ea1c3c82256e18d81b67ef431c01a37ab',
    '$name media',
    '$name media',
    0,
    0,
    0,
    1
), (
    '`echo $mail | sed s/@/+sponsor@/`',
    '8751c23ea1c3c82256e18d81b67ef431c01a37ab',
    '$name sponsor',
    '$name sponsor',
    2,
    1,
    1,
    1
);"

mysql < /kauli/kamikaze/development/sql/data.sql
mysql dev_kauli_auth -e "UPDATE accounts SET password='8d59739760371b5f59c9fc833bb40169e4120ac150c6dfc35646dac43185abdd'"

export KAULI_HOME=/kauli/kamikaze
. /kauli/common/python27/bin/activate

cd /kauli/kamikaze/development/scripts
for i in {1..5}; do
	python create_log.py --debug --date=`date +"%Y-%m-%d" --date "$i days ago"`
done
