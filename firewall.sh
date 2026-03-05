#!/bin/bash

echo "Configuring firewall..."

# Reset firewall
ufw --force reset

# Default policies
ufw default deny incoming
ufw default allow outgoing

# Allow SSH
ufw allow OpenSSH

# Allow web traffic
ufw allow 'Nginx Full'

# Enable firewall
ufw --force enable

echo "Firewall status:"
ufw status verbose

echo "Firewall configured successfully."