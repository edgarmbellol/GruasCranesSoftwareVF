#!/bin/bash

echo "🔄 Generando backup automático de la base de datos..."

# Activar entorno virtual
source /home/mauricio/apps/flask_app/venv/bin/activate

# Navegar al directorio de la aplicación
cd /home/mauricio/apps/flask_app

# Crear directorio para backups si no existe
mkdir -p backups

# Generar nombre del archivo con timestamp
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="backups/gruas_db_backup_${TIMESTAMP}.sql"
COMPRESSED_FILE="backups/gruas_db_backup_${TIMESTAMP}.tar.gz"

echo "📦 Creando backup de la base de datos con parámetros específicos..."
PGPASSWORD=DevGruasCranes123 pg_dump -h localhost -U gruas_user -d gruas_db \
    --encoding=UTF8 \
    --no-owner \
    --no-privileges \
    --clean \
    --if-exists > "$BACKUP_FILE"

# Verificar que el backup se creó correctamente
if [ -f "$BACKUP_FILE" ] && [ -s "$BACKUP_FILE" ]; then
    echo "✅ Backup creado exitosamente: $BACKUP_FILE"
    echo "📊 Tamaño del archivo: $(du -h "$BACKUP_FILE" | cut -f1)"
    
    # Crear un archivo comprimido para facilitar la descarga
    echo "🗜️ Comprimiendo archivo..."
    tar -czf "$COMPRESSED_FILE" "$BACKUP_FILE"
    
    echo ""
    echo "📁 Archivos generados:"
    echo "  - SQL: $BACKUP_FILE"
    echo "  - Comprimido: $COMPRESSED_FILE"
    echo ""
    echo "🌐 URL de descarga:"
    echo "  http://$(hostname -I | awk '{print $1}'):5001/backups/$(basename "$COMPRESSED_FILE")"
    echo ""
    echo "📥 Comando SCP:"
    echo "  scp usuario@$(hostname -I | awk '{print $1}'):$(pwd)/$COMPRESSED_FILE ."
    
    # Limpiar backups antiguos (mantener solo los últimos 5)
    echo ""
    echo "🧹 Limpiando backups antiguos..."
    cd backups
    ls -t gruas_db_backup_*.tar.gz | tail -n +6 | xargs -r rm
    cd ..
    
    echo "✅ Proceso completado"
    
else
    echo "❌ Error al crear el backup"
    exit 1
fi
