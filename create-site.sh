#!/bin/bash

DOMAIN=$1
DEV_MODE=0
for arg in "$@"; do
  [ "$arg" = "--dev" ] && DEV_MODE=1
done

WEBROOT="/var/www/html"
CONFIG_DIR="/etc/flykod-server"
CURRENT_DOMAIN_FILE="$CONFIG_DIR/current_domain"
CURRENT_WEBROOT_FILE="$CONFIG_DIR/current_webroot"
NGINX_IP_DEFAULT="/etc/nginx/sites-available/flykod-ip-default"

if [ -z "$DOMAIN" ]; then
  echo "Usage: bash create-site.sh domain.com [--dev]"
  echo "  --dev   No SSL yet, site accessible by server IP (for when domain is not pointed)"
  exit 1
fi

echo "Configuring site for $DOMAIN (root: $WEBROOT)..."

mkdir -p "$WEBROOT"
mkdir -p "$CONFIG_DIR"

chown -R www-data:www-data "$WEBROOT"
chmod -R 755 "$WEBROOT"

echo "Creating Nginx config..."

if [ $DEV_MODE -eq 1 ]; then
  # Dev: no SSL; site responds to domain when pointed and to IP via default_server
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
else
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
fi

ln -sf /etc/nginx/sites-available/$DOMAIN /etc/nginx/sites-enabled/

if [ $DEV_MODE -eq 1 ]; then
  echo "$DOMAIN" > "$CURRENT_DOMAIN_FILE"
  echo "$WEBROOT" > "$CURRENT_WEBROOT_FILE"

  # Default server for IP access (when domain is not pointed yet)
  cat > "$NGINX_IP_DEFAULT" <<EOL
# Serves the site when accessing by server IP (single site: /var/www/html).
# Updated by create-site.sh --dev and change-domain.sh
server {
    listen 80 default_server;
    server_name _;
    root /var/www/html;
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
  ln -sf "$NGINX_IP_DEFAULT" /etc/nginx/sites-enabled/
  # Disable Ubuntu default so our default_server is used
  rm -f /etc/nginx/sites-enabled/default
fi

echo "Testing Nginx configuration..."
nginx -t || exit 1

echo "Reloading Nginx..."
systemctl reload nginx

if [ $DEV_MODE -eq 1 ]; then
  echo ""
  echo "Site $DOMAIN created (dev mode)."
  echo "  - Access by IP: http://<SERVER_IP> (works before domain is pointed)"
  echo "  - When domain is pointed, run: bash change-domain.sh $DOMAIN seu-dominio-final.com"
  echo "  - Or request SSL for this domain: certbot --nginx -d $DOMAIN -d www.$DOMAIN"
  echo ""
else
  echo "Requesting SSL certificate..."
  certbot --nginx -d $DOMAIN -d www.$DOMAIN --non-interactive --agree-tos -m admin@$DOMAIN --redirect
  echo "Site $DOMAIN created successfully with SSL."
fi
