#!/usr/bin/env python3
"""
Script para forzar la actualización de QR y evitar problemas de caché
"""

import os
import sys
import time
import shutil

# Agregar el directorio del proyecto al path
sys.path.insert(0, '/home/mauricio/apps/flask_app')

from app import app, db
from models import Equipo

def forzar_actualizacion_qr():
    """Forzar actualización de QR para evitar caché"""
    with app.app_context():
        equipos = Equipo.query.filter_by(Estado='activo').all()
        
        print("🔄 Forzando actualización de QR para evitar caché...")
        print("=" * 60)
        
        timestamp = int(time.time())
        
        for equipo in equipos:
            qr_filename = f"qr_equipo_{equipo.IdEquipo}_{equipo.Placa}.png"
            qr_path = os.path.join(app.static_folder, 'qr_codes', qr_filename)
            
            if os.path.exists(qr_path):
                # Crear archivo con timestamp único
                qr_timestamp_filename = f"qr_equipo_{equipo.IdEquipo}_{equipo.Placa}_{timestamp}.png"
                qr_timestamp_path = os.path.join(app.static_folder, 'qr_codes', qr_timestamp_filename)
                
                # Copiar con nuevo nombre
                shutil.copy2(qr_path, qr_timestamp_path)
                
                # Sincronizar a producción
                try:
                    shutil.copy2(qr_timestamp_path, f"/var/www/gruas/static/qr_codes/{qr_timestamp_filename}")
                    os.chmod(f"/var/www/gruas/static/qr_codes/{qr_timestamp_filename}", 0o644)
                    print(f"✅ {equipo.Placa}: QR actualizado con timestamp")
                    print(f"   📁 Local: {qr_timestamp_filename}")
                    print(f"   🌐 URL: https://gestor.gruascranes.com/static/qr_codes/{qr_timestamp_filename}")
                except Exception as e:
                    print(f"⚠️  {equipo.Placa}: Error sincronizando: {e}")
            else:
                print(f"❌ {equipo.Placa}: QR no encontrado")
        
        print(f"\n🎯 Timestamp usado: {timestamp}")
        print("💡 Los QR ahora tienen URLs únicas que evitan el caché")
        print("🔄 Recarga la página para ver los QR actualizados")

def main():
    """Función principal"""
    print("🔄 Forzador de Actualización de QR")
    print("=" * 35)
    
    forzar_actualizacion_qr()

if __name__ == "__main__":
    main()

