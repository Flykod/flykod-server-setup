#!/bin/bash
# Flykod Server - Interactive welcome menu.
# Run this anytime to see the logo and choose an action.

CONFIG_DIR="/etc/flykod-server"
CURRENT_DOMAIN_FILE="$CONFIG_DIR/current_domain"
SITES_DIR="/var/www/sites"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

show_logo() {
  echo ""
  echo "   __ _       _             _ "
  echo "  / _| |     | |           | |"
  echo " | |_| |_   _| | _____   __| |"
  echo " |  _| | | | | |/ / _ \ / _\` |"
  echo " | | | | |_| |   < (_) | (_| |"
  echo " |_| |_|\__, |_|\_\___/ \__,_|"
  echo "         __/ |                "
  echo "        |___/                 "
  echo ""
}

show_info() {
  echo "This machine is a WordPress server (Nginx + PHP + MariaDB)."
  echo "Sites live under: $SITES_DIR"
  echo ""
  echo "--- Server IP (use when domain is not pointed yet) ---"
  ip -4 addr show scope global 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}' || echo "Could not detect IP."
  echo ""
  if [ -f "$CURRENT_DOMAIN_FILE" ]; then
    CURRENT=$(cat "$CURRENT_DOMAIN_FILE")
    echo "--- Default site for IP access ---"
    echo "  Domain: $CURRENT"
    echo ""
  fi
  echo "--- Sites on this server ---"
  if [ -d "$SITES_DIR" ] && [ -n "$(ls -A $SITES_DIR 2>/dev/null)" ]; then
    for dir in "$SITES_DIR"/*/; do
      [ -d "$dir" ] && echo "  - $(basename "$dir")"
    done
  else
    echo "  (none yet)"
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
    show_info
    echo "--- Actions ---"
    echo "  0) Exit"
    echo "  1) Install stack (Nginx, PHP, MariaDB, Certbot)"
    echo "  2) Configure firewall"
    echo "  3) Create site"
    echo "  4) Change domain"
    echo "  5) Install WordPress"
    echo ""
    read -p "Choice [0-5]: " choice

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
      4)
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
      5)
        read -p "Domain (same as in create-site): " domain
        if [ -z "$domain" ]; then
          echo "Domain required."
          prompt_continue
          continue
        fi
        run_script "install-wordpress.sh" "$domain"
        prompt_continue
        ;;
      *)
        echo "Invalid option. Use 0-5."
        prompt_continue
        ;;
    esac
  done
}

main_menu
