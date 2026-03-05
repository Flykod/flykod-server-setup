#!/bin/bash
# Create a MariaDB database and user for WordPress. Credentials are stored and shown once.
# Use show-db-password.sh to see them again if needed.

CONFIG_DIR="/etc/flykod-server"
CREDENTIALS_FILE="$CONFIG_DIR/db-credentials"
DB_NAME="wordpress"
DB_USER="wp_user"
DB_HOST="localhost"

mkdir -p "$CONFIG_DIR"

if [ -f "$CREDENTIALS_FILE" ]; then
  echo "Database was already created. Use menu option 7 (Show database password) to see credentials."
  exit 0
fi

if ! systemctl is-active --quiet mariadb 2>/dev/null && ! systemctl is-active --quiet mysql 2>/dev/null; then
  echo "MariaDB is not running. Install the stack first (menu option 1)."
  exit 1
fi

# Generate a secure random password (24 bytes, base64)
DB_PASS=$(openssl rand -base64 24 | tr -dc 'a-zA-Z0-9' | head -c 32)
[ -z "$DB_PASS" ] && DB_PASS=$(openssl rand -base64 24)

# Create SQL in a temp file to avoid password in process list
TMP_SQL=$(mktemp)
trap "rm -f $TMP_SQL" EXIT
cat > "$TMP_SQL" <<EOSQL
CREATE DATABASE IF NOT EXISTS \`$DB_NAME\`;
CREATE USER IF NOT EXISTS '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASS';
GRANT ALL PRIVILEGES ON \`$DB_NAME\`.* TO '$DB_USER'@'localhost';
FLUSH PRIVILEGES;
EOSQL

if ! mysql < "$TMP_SQL" 2>/dev/null; then
  echo "Failed to create database. Check MariaDB is running and root can connect."
  exit 1
fi

# Store credentials (root only)
cat > "$CREDENTIALS_FILE" <<EOF
DB_NAME=$DB_NAME
DB_USER=$DB_USER
DB_PASS=$DB_PASS
DB_HOST=$DB_HOST
EOF
chmod 600 "$CREDENTIALS_FILE"

echo ""
echo "Database created successfully."
echo ""
echo "--- Save these credentials for WordPress installation ---"
echo "  Database name: $DB_NAME"
echo "  Database user: $DB_USER"
echo "  Database password: $DB_PASS"
echo "  Database host: $DB_HOST"
echo ""
echo "To see this again later: run menu option 7 (Show database password) or: bash show-db-password.sh"
echo ""
