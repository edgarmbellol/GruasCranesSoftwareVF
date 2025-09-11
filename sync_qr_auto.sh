#!/bin/bash
# Script para sincronizar automáticamente los códigos QR

echo "🔄 Sincronizando códigos QR automáticamente..."

# Ejecutar el script de sincronización con permisos de root
sudo python3 /home/mauricio/apps/flask_app/sync_qr_root.py

echo "✅ Sincronización automática completada"

