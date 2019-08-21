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
DB_HOST=${DB_HOST:-cdb-oi3jwf6t.gz.tencentcdb.com}
DB_PORT=${DB_PORT:-10010}
DB_DATABASE=${DB_NAME:-avbook}
DB_USERNAME=${DB_USERNAME:-avbook_gz}
DB_PASSWORD=${DB_PWD:-Avbook123}


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
php artisan key:generate
exec "$@"
