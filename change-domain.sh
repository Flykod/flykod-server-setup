#!/bin/bash
# Change the domain of an existing site (e.g. dev 123.exemplo.com -> exemplo.com).
# Nginx and SSL are updated; you must update WordPress URLs in the database.

OLD_DOMAIN=$1
NEW_DOMAIN=$2
CONFIG_DIR="/etc/flykod-server"
CURRENT_DOMAIN_FILE="$CONFIG_DIR/current_domain"
WEBROOT="/var/www/sites/$OLD_DOMAIN"
NGINX_AVAILABLE="/etc/nginx/sites-available"
NGINX_ENABLED="/etc/nginx/sites-enabled"

if [ -z "$OLD_DOMAIN" ] || [ -z "$NEW_DOMAIN" ]; then
  echo "Usage: bash change-domain.sh OLD_DOMAIN NEW_DOMAIN"
  echo "  Example: bash change-domain.sh 123.exemplo.com exemplo.com"
  exit 1
fi

if [ ! -d "$WEBROOT" ]; then
  echo "Error: Site directory not found: $WEBROOT"
  exit 1
fi

if [ ! -f "$NGINX_AVAILABLE/$OLD_DOMAIN" ]; then
  echo "Error: Nginx config not found for $OLD_DOMAIN"
  exit 1
fi

echo "Changing domain: $OLD_DOMAIN -> $NEW_DOMAIN"
echo "Webroot (unchanged): $WEBROOT"
echo ""

# Update nginx config: new file for new domain; change only server_name (not root path)
OLD_ESC=$(echo "$OLD_DOMAIN" | sed 's/\./\\./g')
sed "/server_name/ s/www\.${OLD_ESC}/www.$NEW_DOMAIN/g; /server_name/ s/${OLD_ESC}/$NEW_DOMAIN/g" \
  "$NGINX_AVAILABLE/$OLD_DOMAIN" > "$NGINX_AVAILABLE/$NEW_DOMAIN"

# Remove old config and symlink, enable new
rm -f "$NGINX_ENABLED/$OLD_DOMAIN"
rm -f "$NGINX_AVAILABLE/$OLD_DOMAIN"
ln -sf "$NGINX_AVAILABLE/$NEW_DOMAIN" "$NGINX_ENABLED/$NEW_DOMAIN"

# If this site is the default for IP access, update current_domain
if [ -f "$CURRENT_DOMAIN_FILE" ] && [ "$(cat "$CURRENT_DOMAIN_FILE")" = "$OLD_DOMAIN" ]; then
  echo "$NEW_DOMAIN" > "$CURRENT_DOMAIN_FILE"
  echo "Updated default site for IP access to $NEW_DOMAIN"
fi

echo "Testing Nginx configuration..."
nginx -t || exit 1

echo "Reloading Nginx..."
systemctl reload nginx

# Request SSL for new domain (if certbot is available and domain is pointed)
echo ""
echo "Requesting SSL for $NEW_DOMAIN..."
if certbot --nginx -d "$NEW_DOMAIN" -d "www.$NEW_DOMAIN" --non-interactive --agree-tos -m "admin@$NEW_DOMAIN" --redirect 2>/dev/null; then
  echo "SSL certificate installed."
else
  echo "SSL could not be requested (point the domain to this server and run):"
  echo "  certbot --nginx -d $NEW_DOMAIN -d www.$NEW_DOMAIN --agree-tos -m admin@$NEW_DOMAIN --redirect"
fi

echo ""
echo "=============================================="
echo "  WORDPRESS: update URLs in the database"
echo "=============================================="
echo "Replace $OLD_DOMAIN with $NEW_DOMAIN in the database."
echo "Options:"
echo "  1) WP-CLI (if installed):"
echo "     cd $WEBROOT && wp search-replace \"$OLD_DOMAIN\" \"$NEW_DOMAIN\" --all-tables"
echo "  2) Plugin: install 'Better Search Replace' and run a search-replace."
echo "  3) Manual: update wp_options (siteurl, home) and any serialized data."
echo "=============================================="
echo ""
echo "Domain change done. Remember to point DNS for $NEW_DOMAIN to this server."
