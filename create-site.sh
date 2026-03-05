#!/bin/bash

DOMAIN=$1
WEBROOT="/var/www/sites/$DOMAIN"

echo "Creating directory for $DOMAIN..."

mkdir -p $WEBROOT

chown -R www-data:www-data $WEBROOT
chmod -R 755 $WEBROOT

echo "Creating Nginx config..."

cat > /etc/nginx/sites-available/$DOMAIN <<EOL
server {
    listen 80;
    server_name $DOMAIN www.$DOMAIN;

    root $WEBROOT;
    index index.php index.html;

    location / {
        try_files \$uri \$uri/ /index.php?\$args;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php8.3-fpm.sock;
    }

    location ~ /\.ht {
        deny all;
    }
}
EOL

ln -s /etc/nginx/sites-available/$DOMAIN /etc/nginx/sites-enabled/

nginx -t
systemctl reload nginx

echo "Site $DOMAIN created successfully."