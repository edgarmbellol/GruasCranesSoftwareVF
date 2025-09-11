#!/bin/bash

# Script de despliegue automático con sincronización de archivos estáticos
# Este script evita problemas de caché sincronizando automáticamente los archivos

echo "🚀 Iniciando despliegue automático..."

# Activar entorno virtual
source venv/bin/activate

# Instalar/actualizar dependencias
echo "📦 Instalando dependencias..."
pip install -r requirements.txt

# Regenerar códigos QR
echo "🔲 Regenerando códigos QR..."
python3 -c "
from app import app, db, Equipo
with app.app_context():
    equipos = Equipo.query.filter_by(Activo=True).all()
    for equipo in equipos:
        app.generar_qr_equipo(equipo.id)
    print(f'✅ {len(equipos)} códigos QR regenerados')
"

# Sincronizar archivos estáticos con el directorio de producción
echo "📁 Sincronizando archivos estáticos..."

# Crear directorios si no existen
sudo mkdir -p /var/www/gruas/static/css
sudo mkdir -p /var/www/gruas/static/js
sudo mkdir -p /var/www/gruas/static/images
sudo mkdir -p /var/www/gruas/static/qr_codes

# Copiar archivos CSS y JS
sudo cp static/css/style.css /var/www/gruas/static/css/
sudo cp static/js/main.js /var/www/gruas/static/js/ 2>/dev/null || echo "⚠️  main.js no encontrado, continuando..."

# Copiar imágenes
sudo cp -r static/images/* /var/www/gruas/static/images/ 2>/dev/null || echo "⚠️  No hay imágenes para copiar"

# Sincronizar códigos QR
sudo cp -r static/qr_codes/* /var/www/gruas/static/qr_codes/ 2>/dev/null || echo "⚠️  No hay códigos QR para copiar"

# Ajustar permisos
echo "🔐 Ajustando permisos..."
sudo chown -R www-data:www-data /var/www/gruas/static/
sudo chmod -R 644 /var/www/gruas/static/css/*
sudo chmod -R 644 /var/www/gruas/static/js/*
sudo chmod -R 644 /var/www/gruas/static/images/*
sudo chmod -R 644 /var/www/gruas/static/qr_codes/*

# Reiniciar servicio
echo "🔄 Reiniciando servicio..."
sudo systemctl restart gruas

# Verificar estado
echo "✅ Verificando estado del servicio..."
if sudo systemctl is-active --quiet gruas; then
    echo "🎉 ¡Despliegue completado exitosamente!"
    echo "📱 Los cambios se aplicarán automáticamente sin necesidad de limpiar caché"
    echo "🌐 La aplicación está disponible en: https://gestor.gruascranes.com"
else
    echo "❌ Error: El servicio no se inició correctamente"
    echo "📋 Revisa los logs con: sudo journalctl -u gruas -f"
fi

echo "🏁 Proceso de despliegue finalizado"
