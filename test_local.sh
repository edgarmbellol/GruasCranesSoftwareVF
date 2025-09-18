#!/bin/bash

echo "🧪 Iniciando prueba local de la aplicación..."

# Activar entorno virtual
source /home/mauricio/apps/flask_app/venv/bin/activate

# Navegar al directorio de la aplicación
cd /home/mauricio/apps/flask_app

# Crear backup de la base de datos actual
echo "📦 Creando backup de la base de datos actual..."
PGPASSWORD=DevGruasCranes123 pg_dump -h localhost -U gruas_user -d gruas_db > backup_antes_test_$(date +%Y%m%d_%H%M%S).sql

# Restaurar el backup en la base de datos
echo "🔄 Restaurando backup en la base de datos..."
PGPASSWORD=DevGruasCranes123 psql -h localhost -U gruas_user -d gruas_db -f backup_gruas_20250917_141529.sql

# Ejecutar la aplicación en modo local
echo "🚀 Iniciando aplicación en modo local..."
echo "🌐 La aplicación estará disponible en: http://localhost:5001"
echo "📱 Para acceder desde otra máquina: http://$(hostname -I | awk '{print $1}'):5001"
echo ""
echo "Presiona Ctrl+C para detener la aplicación"

# Ejecutar la aplicación
FLASK_ENV=production python app.py
