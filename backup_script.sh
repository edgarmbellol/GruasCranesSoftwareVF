#!/bin/bash
# Script de respaldo automático para VPS Ubuntu
# Sistema de Gestión de Grúas

# Configuración
DB_NAME="gruas_db"
DB_USER="gruas_user"
BACKUP_DIR="/var/backups/gruas"
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="gruas_backup_$DATE.sql"

# Crear directorio de respaldos
mkdir -p $BACKUP_DIR

# Crear respaldo de la base de datos
echo "📦 Creando respaldo de la base de datos..."
pg_dump -U $DB_USER -h localhost $DB_NAME > $BACKUP_DIR/$BACKUP_FILE

# Comprimir respaldo
echo "🗜️ Comprimiendo respaldo..."
gzip $BACKUP_DIR/$BACKUP_FILE

# Eliminar respaldos antiguos (más de 30 días)
echo "🧹 Eliminando respaldos antiguos..."
find $BACKUP_DIR -name "*.sql.gz" -mtime +30 -delete

# Crear respaldo de archivos de la aplicación
echo "📁 Creando respaldo de archivos..."
tar -czf $BACKUP_DIR/app_backup_$DATE.tar.gz /var/www/gruas

# Enviar respaldo a almacenamiento en la nube (opcional)
# aws s3 cp $BACKUP_DIR/$BACKUP_FILE.gz s3://tu-bucket/respaldos/
# rclone copy $BACKUP_DIR/$BACKUP_FILE.gz remote:respaldos/

echo "✅ Respaldo completado: $BACKUP_FILE.gz"
echo "📊 Tamaño del respaldo: $(du -h $BACKUP_DIR/$BACKUP_FILE.gz | cut -f1)"
