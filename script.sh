#!/bin/bash

# Pfad zum PHP-Konfigurationsverzeichnis
phpConfigDir="/etc/php"

# Überprüft, ob das Verzeichnis existiert
if [ ! -d "$phpConfigDir" ]; then
  echo "PHP-Konfigurationsverzeichnis nicht gefunden: $phpConfigDir"
  exit 1
fi

# Durchläuft alle PHP-Versionen
phpFpmServices=() # Array zum Speichern der Namen von PHP-FPM-Diensten
for versionDir in $phpConfigDir/*; do
  if [ -d "$versionDir" ]; then
    # Versucht, php.ini Dateien in verschiedenen Unterverzeichnissen zu finden und zu aktualisieren
    for sapiDir in cli fpm cgi; do
      if [ -d "$versionDir/$sapiDir" ]; then  # Überprüft, ob das Unterverzeichnis existiert
        phpIni="$versionDir/$sapiDir/php.ini"
        if [ -f "$phpIni" ]; then
          echo "Aktualisiere $phpIni"
          sed -i 's/upload_max_filesize = .*/upload_max_filesize = 1G/' "$phpIni"
          sed -i 's/post_max_size = .*/post_max_size = 1G/' "$phpIni"
          
          # Fügt den PHP-FPM-Dienst zum Neustart-Array hinzu, wenn es sich um das fpm-Verzeichnis handelt
          if [ "$sapiDir" = "fpm" ]; then
            version=$(basename "$versionDir") # Extrahiert die PHP-Version aus dem Pfad
            phpFpmServices+=("php$version-fpm")
          fi
        else
          echo "php.ini nicht gefunden für: $phpIni"
        fi
      fi
    done
  fi
done

echo "Alle PHP-Konfigurationen wurden aktualisiert."

# Neustart von Apache
echo "Starte Apache neu..."
sudo systemctl restart apache2

# Neustart von PHP-FPM-Diensten
for service in "${phpFpmServices[@]}"; do
  echo "Starte $service neu..."
  sudo systemctl restart "$service"
done

echo "Webserver und PHP-FPM-Dienste wurden neu gestartet."

