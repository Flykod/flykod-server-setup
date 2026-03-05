#!/bin/bash

echo "Updating system..."
apt update && apt upgrade -y

echo "Installing basic packages..."
apt install -y software-properties-common curl git unzip ufw

echo "Installing Nginx..."
apt install -y nginx

echo "Adding PHP repository..."
add-apt-repository ppa:ondrej/php -y
apt update

echo "Installing PHP 8.3..."
apt install -y php8.3 php8.3-fpm php8.3-gd php8.3-mysql php8.3-xml php8.3-curl php8.3-zip php8.3-mbstring php8.3-cli php8.3-common php8.3-opcache php8.3-intl php8.3-imagick

echo "Installing MariaDB..."
apt install -y mariadb-server mariadb-client

echo "Installing Certbot..."
apt install -y certbot python3-certbot-nginx

echo "Creating sites directory..."
mkdir -p /var/www/sites

echo "Setting permissions..."
chown -R www-data:www-data /var/www/sites
chmod -R 755 /var/www/sites

echo "Enabling services..."
systemctl enable nginx
systemctl enable mariadb
systemctl enable php8.3-fpm

echo "Server stack installation completed."