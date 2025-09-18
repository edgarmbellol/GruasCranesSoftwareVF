#!/usr/bin/env python3
"""
Script para regenerar códigos QR de equipos con la nueva funcionalidad de referencia
"""

import os
import sys
import qrcode
from PIL import Image

# Agregar el directorio del proyecto al path
sys.path.append('/home/mauricio/apps/flask_app')

# Configurar variables de entorno
os.environ['FLASK_APP'] = 'app.py'
os.environ['FLASK_ENV'] = 'production'

from app import app, db
from models import Equipo

def regenerar_qr_con_referencia():
    """Regenera todos los códigos QR de equipos activos"""
    with app.app_context():
        equipos = Equipo.query.filter_by(Estado='activo').all()
        
        print("🔄 Regenerando códigos QR con funcionalidad de referencia...")
        print("=" * 60)
        
        for equipo in equipos:
            try:
                # Crear directorio para QR si no existe
                qr_dir = os.path.join(app.static_folder, 'qr_codes')
                if not os.path.exists(qr_dir):
                    os.makedirs(qr_dir)
                
                # URL del panel del equipo
                base_url = 'https://gestor.gruascranes.com'
                url_panel = f"{base_url}/equipo/{equipo.IdEquipo}"
                
                print(f"🔍 Generando QR para equipo {equipo.IdEquipo} ({equipo.Placa})")
                print(f"   📋 Referencia: {equipo.Referencia or 'Sin referencia'}")
                print(f"   🚛 Tipo: {equipo.tipo_equipo.descripcion if equipo.tipo_equipo else 'N/A'}")
                print(f"   🌐 URL: {url_panel}")
                
                # Crear código QR
                qr = qrcode.QRCode(
                    version=1,
                    error_correction=qrcode.constants.ERROR_CORRECT_L,
                    box_size=10,
                    border=4,
                )
                qr.add_data(url_panel)
                qr.make(fit=True)
                
                # Crear imagen del QR
                img = qr.make_image(fill_color="black", back_color="white")
                
                # Guardar imagen
                filename = f"qr_equipo_{equipo.IdEquipo}_{equipo.Placa}.png"
                filepath = os.path.join(qr_dir, filename)
                img.save(filepath)
                
                print(f"   ✅ QR guardado en {filepath}")
                
                # Sincronizar con producción
                try:
                    prod_path = f"/var/www/gruas/static/qr_codes/{filename}"
                    os.makedirs(os.path.dirname(prod_path), exist_ok=True)
                    img.save(prod_path)
                    os.chmod(prod_path, 0o644)
                    print(f"   🔄 Sincronizado con producción")
                except Exception as e:
                    print(f"   ⚠️  Error sincronizando: {e}")
                
                print()
                
            except Exception as e:
                print(f"❌ Error generando QR para equipo {equipo.IdEquipo} ({equipo.Placa}): {str(e)}")
                print()
        
        print("🎯 Regeneración completada!")
        print("💡 Los QR ahora incluyen la referencia del equipo en la impresión")

if __name__ == "__main__":
    regenerar_qr_con_referencia()
