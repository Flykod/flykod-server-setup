#!/bin/bash
# Flykod Server - Interactive welcome menu.
# Run this anytime to see the logo and choose an action.

CONFIG_DIR="/etc/flykod-server"
CURRENT_DOMAIN_FILE="$CONFIG_DIR/current_domain"
CREDENTIALS_FILE="$CONFIG_DIR/db-credentials"
SITE_ROOT="/var/www/html"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Flykod green #00F10A (RGB 0, 241, 10) - ANSI 24-bit
GREEN='\033[38;2;0;241;10m'
UL='\033[4m'
RESET='\033[0m'

show_logo() {
  echo ""
  echo -e "${GREEN}   __ _       _             _ "
  echo -e "  / _| |     | |           | |"
  echo -e " | |_| |_   _| | _____   __| |"
  echo -e " |  _| | | | | |/ / _ \ / _\` |"
  echo -e " | | | | |_| |   < (_) | (_| |"
  echo -e " |_| |_|\__, |_|\_\___/ \__,_|"
  echo -e "         __/ |                "
  echo -e "        |___/                 ${RESET}"
  echo ""
}

show_greeting() {
  echo -e "Powered by Flykod · ${GREEN}${UL}https://flykod.com${RESET}"
  echo ""
  echo ""
  echo "===================================================================================="
  echo ""
  echo "WELCOME!"
  echo ""
  echo "This server is set up for one WordPress site — use the menu below to get started."
  echo ""
  echo "===================================================================================="
  echo ""
  echo ""
  echo ""
}

check_stack() {
  if command -v nginx &>/dev/null && systemctl is-active --quiet nginx 2>/dev/null \
     && (systemctl is-active --quiet php8.3-fpm 2>/dev/null || systemctl is-active --quiet php*-fpm 2>/dev/null) \
     && (systemctl is-active --quiet mariadb 2>/dev/null || systemctl is-active --quiet mysql 2>/dev/null) \
     && command -v certbot &>/dev/null; then
    echo "yes"
  else
    echo "no"
  fi
}

check_firewall() {
  if command -v ufw &>/dev/null && ufw status 2>/dev/null | grep -q "Status: active"; then
    echo "yes"
  else
    echo "no"
  fi
}

show_checklist() {
  echo "--- Checklist ---"
  if [ "$(check_stack)" = "yes" ]; then
    echo -e "  [ ${GREEN}✓${RESET} ] - Stack (Nginx, PHP, MariaDB, Certbot)"
  else
    echo "  [   ] - Stack (Nginx, PHP, MariaDB, Certbot)"
  fi
  if [ "$(check_firewall)" = "yes" ]; then
    echo -e "  [ ${GREEN}✓${RESET} ] - Firewall (UFW)"
  else
    echo "  [   ] - Firewall (UFW)"
  fi
  if [ -f "$CREDENTIALS_FILE" ]; then
    echo -e "  [ ${GREEN}✓${RESET} ] - Database (local)"
  else
    echo "  [   ] - Database (skip if using external DB)"
  fi
  if [ -f "$CURRENT_DOMAIN_FILE" ]; then
    echo -e "  [ ${GREEN}✓${RESET} ] - Create site"
  else
    echo "  [   ] - Create site"
  fi
  if [ -f "$SITE_ROOT/wp-login.php" ] || [ -f "$SITE_ROOT/wp-config.php" ]; then
    echo -e "  [ ${GREEN}✓${RESET} ] - WordPress"
  else
    echo "  [   ] - WordPress"
  fi
  echo ""
}

show_info() {
  echo "This machine is a WordPress server (Nginx + PHP + MariaDB)."
  echo "Site root: $SITE_ROOT"
  echo ""
  echo "--- Server IP (use when domain is not pointed yet) ---"
  PUBLIC_IP=$(ip -4 addr show scope global 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | grep -vE '^10\.|^172\.(1[6-9]|2[0-9]|3[0-1])\.|^192\.168\.' | head -1)
  if [ -n "$PUBLIC_IP" ]; then
    echo -e "  Public: ${GREEN}${PUBLIC_IP}${RESET}"
  else
    echo "  Could not detect public IP."
  fi
  echo ""
  if [ -f "$CURRENT_DOMAIN_FILE" ]; then
    CURRENT=$(cat "$CURRENT_DOMAIN_FILE")
    echo "--- Domain / IP access ---"
    echo -e "  Domain: ${GREEN}${UL}${CURRENT}${RESET}"
    echo "  Domain not pointed yet — use the Public IP above to access the site."
    echo ""
  fi
  echo ""
}

run_script() {
  local script="$1"
  local args="$2"
  if [ -f "$SCRIPT_DIR/$script" ]; then
    (cd "$SCRIPT_DIR" && bash "$script" $args)
  else
    echo "Script not found: $script"
  fi
}

prompt_continue() {
  echo ""
  read -p "Press Enter to continue..."
}

main_menu() {
  while true; do
    clear
    show_logo
    show_greeting
    show_info
    show_checklist
    echo "--- Actions ---"
    echo "  0) Exit"
    echo "  1) Install stack (Nginx, PHP, MariaDB, Certbot)"
    echo "  2) Configure firewall"
    echo "  3) Create database (local; skip if using external DB)"
    echo "  4) Create site"
    echo "  5) Install WordPress"
    echo "  6) Change domain"
    echo "  7) Show database password"
    echo ""
    read -p "Choice [0-7]: " choice

    case "$choice" in
      0)
        echo "Bye."
        exit 0
        ;;
      1)
        run_script "install-stack.sh"
        prompt_continue
        ;;
      2)
        run_script "firewall.sh"
        prompt_continue
        ;;
      3)
        run_script "create-database.sh"
        prompt_continue
        ;;
      4)
        read -p "Domain (e.g. example.com or dev.example.com): " domain
        if [ -z "$domain" ]; then
          echo "Domain required."
          prompt_continue
          continue
        fi
        read -p "Dev mode? Access by IP, no SSL yet [y/N]: " dev
        if [[ "$dev" =~ ^[yY] ]]; then
          run_script "create-site.sh" "$domain --dev"
        else
          run_script "create-site.sh" "$domain"
        fi
        prompt_continue
        ;;
      5)
        run_script "install-wordpress.sh"
        prompt_continue
        ;;
      6)
        read -p "Current domain: " old_domain
        read -p "New domain: " new_domain
        if [ -z "$old_domain" ] || [ -z "$new_domain" ]; then
          echo "Both domains required."
          prompt_continue
          continue
        fi
        run_script "change-domain.sh" "$old_domain $new_domain"
        prompt_continue
        ;;
      7)
        run_script "show-db-password.sh"
        prompt_continue
        ;;
      *)
        echo "Invalid option. Use 0-7."
        prompt_continue
        ;;
    esac
  done
}

main_menu
