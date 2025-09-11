#!/usr/bin/env python3
"""
Script para generar QR con nombres únicos y evitar problemas de caché
"""

import os
import sys
import time
import shutil

# Agregar el directorio del proyecto al path
sys.path.insert(0, '/home/mauricio/apps/flask_app')

from app import app, db
from models import Equipo

def generar_qr_sin_cache():
    """Generar QR con nombres únicos para evitar caché"""
    with app.app_context():
        equipos = Equipo.query.filter_by(Estado='activo').all()
        
        print("🔄 Generando QR sin problemas de caché...")
        print("=" * 50)
        
        timestamp = int(time.time())
        
        for equipo in equipos:
            # Generar QR con timestamp único
            qr_filename = f"qr_equipo_{equipo.IdEquipo}_{equipo.Placa}_{timestamp}.png"
            qr_path = os.path.join(app.static_folder, 'qr_codes', qr_filename)
            
            # Generar QR usando la función existente
            from app import generar_qr_equipo
            qr_generated = generar_qr_equipo(equipo.IdEquipo, equipo.Placa)
            
            if qr_generated and os.path.exists(qr_generated):
                # Renombrar con timestamp
                shutil.move(qr_generated, qr_path)
                
                # Sincronizar a producción
                try:
                    shutil.copy2(qr_path, f"/var/www/gruas/static/qr_codes/{qr_filename}")
                    os.chmod(f"/var/www/gruas/static/qr_codes/{qr_filename}", 0o644)
                    print(f"✅ {equipo.Placa}: QR generado sin caché")
                    print(f"   📁 Archivo: {qr_filename}")
                    print(f"   🌐 URL: https://gestor.gruascranes.com/static/qr_codes/{qr_filename}")
                except Exception as e:
                    print(f"⚠️  {equipo.Placa}: Error sincronizando: {e}")
            else:
                print(f"❌ {equipo.Placa}: Error generando QR")
        
        print(f"\n🎯 Timestamp usado: {timestamp}")
        print("💡 Los QR ahora tienen nombres únicos que evitan el caché")
        print("🔄 Recarga la página para ver los QR actualizados")

def main():
    """Función principal"""
    print("🔄 Generador de QR Sin Caché")
    print("=" * 30)
    
    generar_qr_sin_cache()

if __name__ == "__main__":
    main()

