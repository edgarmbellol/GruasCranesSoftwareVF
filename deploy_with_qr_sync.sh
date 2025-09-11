#!/bin/bash
# Script de despliegue con sincronización automática de códigos QR
# GRÚAS CRANES S.A.S

echo "🚀 GRÚAS CRANES S.A.S - Despliegue con Sincronización QR"
echo "========================================================"

# Verificar que estamos en el directorio correcto
if [ ! -f "app.py" ]; then
    echo "❌ Error: No se encontró app.py. Ejecuta desde el directorio de la aplicación."
    exit 1
fi

# 1. Activar entorno virtual
echo "📦 Activando entorno virtual..."
source venv/bin/activate

# 2. Actualizar dependencias si es necesario
echo "📋 Verificando dependencias..."
pip install -r requirements.txt

# 3. Regenerar códigos QR
echo "🔄 Regenerando códigos QR..."
python3 -c "
from app import app, db, Equipo, regenerar_todos_qr
with app.app_context():
    exitosos, errores = regenerar_todos_qr()
    print(f'QR generados: {exitosos}, Errores: {errores}')
"

# 4. Sincronizar con producción
echo "🔄 Sincronizando códigos QR con producción..."
sudo python3 sync_qr_production.py

# 5. Reiniciar aplicación
echo "🔄 Reiniciando aplicación..."
sudo systemctl restart gruas-cranes

# 6. Verificar estado
echo "🔍 Verificando estado de la aplicación..."
sleep 3
if systemctl is-active --quiet gruas-cranes; then
    echo "✅ Aplicación reiniciada correctamente"
else
    echo "❌ Error al reiniciar la aplicación"
    exit 1
fi

# 7. Verificar códigos QR
echo "🔍 Verificando códigos QR..."
curl -s -o /dev/null -w "%{http_code}" https://gestor.gruascranes.com/qr_codes/qr_equipo_1_beu953.png
if [ $? -eq 0 ]; then
    echo "✅ Códigos QR accesibles"
else
    echo "❌ Error: Códigos QR no accesibles"
fi

echo ""
echo "🎉 ¡Despliegue completado exitosamente!"
echo "🌐 Aplicación: https://gestor.gruascranes.com"
echo "📱 Códigos QR: https://gestor.gruascranes.com/qr-equipos"
echo ""
