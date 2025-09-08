#!/bin/bash

# Script para configurar SSL con Let's Encrypt
# Uso: ./setup-ssl.sh tu-dominio.com

set -e

DOMAIN=$1

if [ -z "$DOMAIN" ]; then
    echo "❌ Error: Debes proporcionar un dominio"
    echo "Uso: ./setup-ssl.sh tu-dominio.com"
    exit 1
fi

echo "🔒 Configurando SSL para $DOMAIN..."

# Instalar Certbot
sudo apt update
sudo apt install -y certbot python3-certbot-nginx

# Obtener certificado SSL
sudo certbot --nginx -d $DOMAIN -d www.$DOMAIN

# Configurar renovación automática
sudo crontab -l | { cat; echo "0 12 * * * /usr/bin/certbot renew --quiet"; } | sudo crontab -

echo "✅ SSL configurado correctamente para $DOMAIN"
echo "🌐 Tu aplicación ahora está disponible en: https://$DOMAIN"
