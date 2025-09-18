#!/bin/bash

echo "📥 Preparando descarga de la base de datos..."

# Activar entorno virtual
source /home/mauricio/apps/flask_app/venv/bin/activate

# Navegar al directorio de la aplicación
cd /home/mauricio/apps/flask_app

# Crear directorio para backups si no existe
mkdir -p backups

# Generar nombre del archivo con timestamp
BACKUP_FILE="backups/gruas_db_backup_$(date +%Y%m%d_%H%M%S).sql"

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
    COMPRESSED_FILE="${BACKUP_FILE%.sql}.tar.gz"
    echo "🗜️ Comprimiendo archivo..."
    tar -czf "$COMPRESSED_FILE" "$BACKUP_FILE"
    
    echo ""
    echo "📁 Archivos generados:"
    echo "  - SQL: $BACKUP_FILE"
    echo "  - Comprimido: $COMPRESSED_FILE"
    echo ""
    echo "📥 Para descargar desde tu máquina local:"
    echo "  scp usuario@$(hostname -I | awk '{print $1}'):$(pwd)/$COMPRESSED_FILE ."
    echo ""
    echo "🔧 Para restaurar en tu máquina local:"
    echo "  tar -xzf $(basename "$COMPRESSED_FILE")"
    echo "  psql -U tu_usuario -d tu_base_datos -f $(basename "$BACKUP_FILE")"
    echo ""
    echo "🌐 O puedes descargar directamente desde el navegador:"
    echo "  http://$(hostname -I | awk '{print $1}'):5001/backups/$(basename "$COMPRESSED_FILE")"
    
else
    echo "❌ Error al crear el backup"
    exit 1
fi
