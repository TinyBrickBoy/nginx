#!/bin/ash
# Sicherstellen, dass der Skript bei Fehlern stoppt
set -e

cd /home/container

# Replace Startup Variables
MODIFIED_STARTUP=$(eval echo $(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g'))

# Erstelle webroot/vendor Verzeichnis, falls es nicht existiert
if [ ! -d "/home/container/webroot/vendor" ]; then
    echo "Erstelle webroot/vendor Verzeichnis..."
    mkdir -p /home/container/webroot/vendor
fi

# Überprüfen, ob composer.json existiert und Abhängigkeiten installieren
if [ -f "/home/container/webroot/composer.json" ]; then
    cd /home/container/webroot
    
    if [ ! -f "/home/container/webroot/vendor/autoload.php" ]; then
        echo "vendor/autoload.php nicht gefunden. Führe composer install aus..."
        composer install --no-interaction --no-progress
        
        # Falls immer noch nicht vorhanden, versuche es mit einem erneuten Dump
        if [ ! -f "/home/container/webroot/vendor/autoload.php" ]; then
            echo "Versuche composer dump-autoload..."
            composer dump-autoload --optimize
        fi
    fi
    
    # Zurück zum Hauptverzeichnis
    cd /home/container
fi

echo ":/home/container$ ${MODIFIED_STARTUP}"

# Run the Server
${MODIFIED_STARTUP}
