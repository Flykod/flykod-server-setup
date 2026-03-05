#!/bin/bash
# Show stored database credentials (e.g. if you lost the password).

CREDENTIALS_FILE="/etc/flykod-server/db-credentials"

if [ ! -f "$CREDENTIALS_FILE" ]; then
  echo "No stored database credentials found."
  echo "Create a database first (menu option 6), or you are using an external database."
  exit 0
fi

echo ""
echo "--- Database credentials (sensitive) ---"
cat "$CREDENTIALS_FILE"
echo ""
echo "Use these when installing WordPress in the browser or in wp-config.php."
echo ""
