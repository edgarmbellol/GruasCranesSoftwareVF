#!/bin/bash

echo "📥 Obteniendo el último backup de la base de datos..."

# Activar entorno virtual
source /home/mauricio/apps/flask_app/venv/bin/activate

# Navegar al directorio de la aplicación
cd /home/mauricio/apps/flask_app

# Buscar el último archivo de backup
LATEST_BACKUP=$(ls -t backups/gruas_db_backup_*.tar.gz | head -1)

if [ -z "$LATEST_BACKUP" ]; then
    echo "❌ No se encontraron archivos de backup"
    exit 1
fi

echo "📦 Último backup encontrado: $(basename "$LATEST_BACKUP")"
echo "📊 Tamaño: $(du -h "$LATEST_BACKUP" | cut -f1)"
echo "📅 Fecha: $(stat -c %y "$LATEST_BACKUP")"
echo ""

echo "🌐 URL de descarga directa:"
echo "  http://$(hostname -I | awk '{print $1}'):5001/backups/$(basename "$LATEST_BACKUP")"
echo ""

echo "📥 Comando SCP:"
echo "  scp usuario@$(hostname -I | awk '{print $1}'):$(pwd)/$LATEST_BACKUP ."
echo ""

echo "🔧 Para restaurar en tu máquina local:"
echo "  1. tar -xzf $(basename "$LATEST_BACKUP")"
echo "  2. createdb -U tu_usuario gruas_local"
echo "  3. psql -U tu_usuario -d gruas_local -f $(basename "$LATEST_BACKUP" .tar.gz).sql"
echo ""

echo "✅ Backup listo para descarga con parámetros:"
echo "  - UTF8 encoding"
echo "  - Sin información de propietario"
echo "  - Sin información de privilegios"
echo "  - Limpia objetos antes de crear"
echo "  - Evita errores si no existen objetos"
