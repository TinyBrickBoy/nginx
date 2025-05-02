#!/bin/ash
# Sicherstellen, dass der Skript bei Fehlern stoppt
set -e

cd /home/container

# Überprüfen, ob vendor/autoload.php existiert und Composer-Abhängigkeiten installieren
if [ -f "composer.json" ]; then
  if [ ! -f "vendor/autoload.php" ]; then
    echo "vendor/autoload.php nicht gefunden. Führe composer install aus..."
    composer install --no-interaction --no-progress
    
    # Falls immer noch nicht vorhanden, versuche es mit einem erneuten Dump
    if [ ! -f "vendor/autoload.php" ]; then
      echo "Versuche composer dump-autoload..."
      composer dump-autoload --optimize
    fi
  fi
fi

# Replace Startup Variables
MODIFIED_STARTUP=$(eval echo $(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g'))
echo ":/home/container$ ${MODIFIED_STARTUP}"

# Run the Server
${MODIFIED_STARTUP}
