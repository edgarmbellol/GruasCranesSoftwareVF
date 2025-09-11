#!/bin/bash
# Script para sincronizar códigos QR con el directorio de producción

echo "🔄 Sincronizando códigos QR..."

# Crear directorio si no existe
sudo mkdir -p /var/www/gruas/static/qr_codes

# Establecer permisos del directorio
sudo chown www-data:www-data /var/www/gruas/static/qr_codes/
sudo chmod 755 /var/www/gruas/static/qr_codes/

# Copiar archivos QR
sudo cp /home/mauricio/apps/flask_app/static/qr_codes/* /var/www/gruas/static/qr_codes/

# Ajustar permisos de archivos
sudo chown www-data:www-data /var/www/gruas/static/qr_codes/*
sudo chmod 644 /var/www/gruas/static/qr_codes/*

echo "✅ Códigos QR sincronizados correctamente"
echo "📁 Archivos en: /var/www/gruas/static/qr_codes/"
echo "🌐 Accesibles en: https://gestor.gruascranes.com/static/qr_codes/"
