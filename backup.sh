#!/bin/bash

# Script de backup para el sistema de grúas
# Uso: ./backup.sh

set -e

BACKUP_DIR="/app/backups"
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="gruas_backup_$DATE.tar.gz"

echo "💾 Iniciando backup del sistema..."

# Crear directorio de backup
sudo mkdir -p $BACKUP_DIR

# Crear backup de la base de datos
echo "📊 Respaldando base de datos..."
sudo -u postgres pg_dump gruas_db > /tmp/gruas_db_backup.sql

# Crear backup de archivos
echo "📁 Respaldando archivos..."
sudo tar -czf $BACKUP_DIR/$BACKUP_FILE \
    -C /app/gruas \
    --exclude=venv \
    --exclude=__pycache__ \
    --exclude=*.pyc \
    .

# Agregar backup de BD al archivo
sudo tar -czf $BACKUP_DIR/gruas_backup_$DATE.tar.gz \
    -C /tmp \
    gruas_db_backup.sql \
    -C $BACKUP_DIR \
    $BACKUP_FILE

# Limpiar archivos temporales
sudo rm -f /tmp/gruas_db_backup.sql
sudo rm -f $BACKUP_DIR/$BACKUP_FILE

# Mantener solo los últimos 7 backups
sudo find $BACKUP_DIR -name "gruas_backup_*.tar.gz" -mtime +7 -delete

echo "✅ Backup completado: $BACKUP_DIR/gruas_backup_$DATE.tar.gz"
