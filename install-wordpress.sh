#!/bin/bash

DOMAIN=$1
WEBROOT="/var/www/sites/$DOMAIN"

echo "Downloading WordPress..."

cd /tmp
curl -O https://wordpress.org/latest.tar.gz
tar -xvf latest.tar.gz

echo "Moving files..."

cp -R wordpress/* $WEBROOT

chown -R www-data:www-data $WEBROOT

echo "WordPress installed in $WEBROOT"