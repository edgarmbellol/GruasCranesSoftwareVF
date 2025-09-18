#!/bin/bash

echo "🔄 Restaurando base de datos original..."

# Activar entorno virtual
source /home/mauricio/apps/flask_app/venv/bin/activate

# Navegar al directorio de la aplicación
cd /home/mauricio/apps/flask_app

# Buscar el último backup creado antes del test
BACKUP_FILE=$(ls -t backup_antes_test_*.sql | head -1)

if [ -z "$BACKUP_FILE" ]; then
    echo "❌ No se encontró backup para restaurar"
    echo "📋 Archivos de backup disponibles:"
    ls -la backup_*.sql
    exit 1
fi

echo "📦 Restaurando desde: $BACKUP_FILE"

# Restaurar el backup
PGPASSWORD=DevGruasCranes123 psql -h localhost -U gruas_user -d gruas_db -f "$BACKUP_FILE"

echo "✅ Base de datos restaurada exitosamente"
echo "🌐 La aplicación de producción está funcionando con los datos originales"
