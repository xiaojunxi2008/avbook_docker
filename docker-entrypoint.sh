#!/bin/sh
cat > .env << EOF
{
APP_NAME=Laravel
APP_ENV=local
APP_KEY=
APP_DEBUG=true
APP_URL=

LOG_CHANNEL=stack

DB_CONNECTION=mysql
DB_HOST=${DB_HOST:-127.0.0.1}
DB_PORT=${DB_PORT:-3306}
DB_DATABASE=${DB_NAME:-avbook}
DB_USERNAME=${DB_USERNAME:-root}
DB_PASSWORD=${DB_PWD:-avbook111}


BROADCAST_DRIVER=log
CACHE_DRIVER=file
QUEUE_CONNECTION=sync
SESSION_DRIVER=file
SESSION_LIFETIME=120

REDIS_HOST=127.0.0.1
REDIS_PASSWORD=null
REDIS_PORT=6379

MAIL_DRIVER=smtp
MAIL_HOST=smtp.mailtrap.io
MAIL_PORT=2525
MAIL_USERNAME=null
MAIL_PASSWORD=null
MAIL_ENCRYPTION=null

AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=
AWS_DEFAULT_REGION=us-east-1
AWS_BUCKET=

PUSHER_APP_ID=
PUSHER_APP_KEY=
PUSHER_APP_SECRET=
PUSHER_APP_CLUSTER=mt1

MIX_PUSHER_APP_KEY=""
MIX_PUSHER_APP_CLUSTER="${PUSHER_APP_CLUSTER}"
}
EOF
mv /etc/nginx/nginx.conf  /etc/nginx/nginx.conf.b
cat > /etc/nginx/nginx.conf << EOF
user root;
worker_processes auto;
error_log /var/log/nginx/error.log;
pid /run/nginx.pid;

# Load dynamic modules. See /usr/share/nginx/README.dynamic.
include /usr/share/nginx/modules/*.conf;

events {
    worker_connections 1024;
}

http
{

        log_format  main  '\$remote_addr - \$remote_user [\$time_local] "\$request" '
                      '\$status \$body_bytes_sent "\$http_referer" '
                      '"\$http_user_agent" "\$http_x_forwarded_for"';

        access_log  /var/log/nginx/access.log  main;

        sendfile            on;
        tcp_nopush          on;
        tcp_nodelay         on;
        keepalive_timeout   65;
        types_hash_max_size 2048;

        include             /etc/nginx/mime.types;
        default_type        application/octet-stream;
        include /etc/nginx/conf.d/*.conf;
	server { 
        	listen 8999;
        	server_name  _;
       		location / {
            		proxy_pass  http://127.0.0.1:8000;
            		proxy_http_version 1.1;
            		proxy_set_header   Upgrade \$http_upgrade;
            		proxy_set_header   Connection keep-alive;
            		proxy_set_header   Host \$host:\$server_port;
            		proxy_cache_bypass \$http_upgrade;
            		proxy_set_header   X-Forwarded-For \$proxy_add_x_forwarded_for;
            		proxy_set_header   X-Forwarded-Proto \$scheme;
        }
    }
}
EOF
service nginx reload
nginx
service mysql start
mv /etc/mysql/mariadb.conf.d/50-server.cnf  /etc/mysql/mariadb.conf.d/50-server.cnf.b
cat > /etc/mysql/mariadb.conf.d/50-server.cnf << EOF
[server]

[mysqld]

user            = mysql
pid-file        = /var/run/mysqld/mysqld.pid
socket          = /var/run/mysqld/mysqld.sock
port            = 3306
basedir         = /usr
datadir         = /var/lib/mysql
tmpdir          = /tmp
lc-messages-dir = /usr/share/mysql
skip-external-locking

bind-address            = 0.0.0.0

key_buffer_size         = 16M
max_allowed_packet      = 16M
thread_stack            = 192K
thread_cache_size       = 8

myisam_recover_options  = BACKUP

query_cache_limit       = 1M
query_cache_size        = 16M

log_error = /var/log/mysql/error.log

expire_logs_days        = 10
max_binlog_size   = 100M

character-set-server  = utf8mb4
collation-server      = utf8mb4_general_ci

[embedded]

[mariadb]

[mariadb-10.1]
EOF
mysql -u root  <<EOF
source /home/bookdata.sql;
EOF
#mysqldump -u root avbook >/home/bookdata.sql
mysql -u root  <<EOF
USE mysql;
UPDATE mysql.user SET authentication_string = PASSWORD('${MYSQL_PWD:-avbook111}'), plugin = 'mysql_native_password' WHERE User = 'root' AND Host = 'localhost';
FLUSH PRIVILEGES;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '${MYSQL_PWD:-avbook111}' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF
service mysql restart
php artisan key:generate
exec "$@"
