#!/bin/sh
cd /home/container

# Display startup message
echo "Starting Nginx with PHP 8.3 container..."

# Create required directories if they don't exist
mkdir -p /home/container/public
mkdir -p /home/container/logs/nginx
mkdir -p /home/container/logs/php

# Configure basic Nginx service
cat > /etc/nginx/http.d/default.conf <<EOL
server {
    listen 80 default_server;
    listen [::]:80 default_server;
    
    root /home/container/public;
    index index.php index.html index.htm;
    
    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }
    
    location ~ \.php$ {
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass 127.0.0.1:9000;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        fastcgi_param PHP_VALUE "upload_max_filesize = 100M \n post_max_size=100M";
    }
}
EOL

# Configure supervisor to manage services
cat > /etc/supervisord.conf <<EOL
[supervisord]
nodaemon=true
user=root
logfile=/dev/stdout
logfile_maxbytes=0

[program:php-fpm]
command=/usr/sbin/php-fpm83 -F
autostart=true
autorestart=true
priority=5

[program:nginx]
command=/usr/sbin/nginx -g "daemon off;"
autostart=true
autorestart=true
priority=10
EOL
