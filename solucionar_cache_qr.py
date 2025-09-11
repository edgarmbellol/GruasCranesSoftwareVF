#!/usr/bin/env python3
"""
Script para solucionar el problema de caché de QR
"""

import os
import sys
import time

# Agregar el directorio del proyecto al path
sys.path.insert(0, '/home/mauricio/apps/flask_app')

from app import app, db
from models import Equipo

def agregar_cache_busting():
    """Agregar cache busting a las URLs de QR"""
    with app.app_context():
        equipos = Equipo.query.filter_by(Estado='activo').all()
        
        print("🔧 Solucionando problema de caché de QR...")
        print("=" * 50)
        
        timestamp = int(time.time())
        
        for equipo in equipos:
            qr_filename = f"qr_equipo_{equipo.IdEquipo}_{equipo.Placa}.png"
            qr_path = os.path.join(app.static_folder, 'qr_codes', qr_filename)
            
            if os.path.exists(qr_path):
                # Crear un archivo con timestamp para cache busting
                qr_with_timestamp = f"qr_equipo_{equipo.IdEquipo}_{equipo.Placa}_{timestamp}.png"
                qr_timestamp_path = os.path.join(app.static_folder, 'qr_codes', qr_with_timestamp)
                
                # Copiar el archivo con nuevo nombre
                import shutil
                shutil.copy2(qr_path, qr_timestamp_path)
                
                print(f"✅ {equipo.Placa}: QR con timestamp creado")
                print(f"   📁 Archivo: {qr_with_timestamp}")
                print(f"   🌐 URL: /static/qr_codes/{qr_with_timestamp}")
            else:
                print(f"❌ {equipo.Placa}: QR no encontrado")
        
        print(f"\n🎯 Timestamp usado: {timestamp}")
        print("💡 Ahora los QR tendrán URLs únicas que evitan el caché")

def main():
    """Función principal"""
    print("🔧 Solucionador de Caché de QR")
    print("=" * 30)
    
    agregar_cache_busting()

if __name__ == "__main__":
    main()

