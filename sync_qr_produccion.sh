#!/bin/bash

echo "🔄 Sincronizando códigos QR con producción..."

# Crear directorio si no existe
sudo mkdir -p /var/www/gruas/static/qr_codes/

# Copiar archivos QR
sudo cp -r /home/mauricio/apps/flask_app/static/qr_codes/* /var/www/gruas/static/qr_codes/

# Aplicar permisos correctos
sudo chmod -R 644 /var/www/gruas/static/qr_codes/
sudo chown -R www-data:www-data /var/www/gruas/static/qr_codes/

echo "✅ Códigos QR sincronizados con producción"
echo "📊 Archivos sincronizados:"
ls -la /var/www/gruas/static/qr_codes/ | wc -l
echo "archivos QR en producción"
