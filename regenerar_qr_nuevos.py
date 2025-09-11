#!/usr/bin/env python3
"""
Script para regenerar códigos QR de equipos
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

def generar_qr_equipo(equipo_id, placa):
    """Genera un código QR para un equipo específico"""
    try:
        # Crear directorio para QR si no existe
        qr_dir = os.path.join(app.static_folder, 'qr_codes')
        if not os.path.exists(qr_dir):
            os.makedirs(qr_dir)
        
        # URL del panel del equipo
        base_url = 'https://gestor.gruascranes.com'
        url_panel = f"{base_url}/equipo/{equipo_id}"
        
        print(f"🔍 Generando QR para equipo {equipo_id} ({placa})")
        print(f"🔍 URL: {url_panel}")
        
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
        filename = f"qr_equipo_{equipo_id}_{placa}.png"
        filepath = os.path.join(qr_dir, filename)
        img.save(filepath)
        
        print(f"✅ QR guardado en {filepath}")
        
        # Verificar que el archivo existe
        if os.path.exists(filepath):
            file_size = os.path.getsize(filepath)
            print(f"✅ Archivo verificado: {file_size} bytes")
            return f"qr_codes/{filename}"
        else:
            print(f"❌ Error: Archivo no encontrado después de guardar")
            return None
            
    except Exception as e:
        print(f"❌ Error generando QR para equipo {equipo_id}: {str(e)}")
        return None

def main():
    """Función principal"""
    with app.app_context():
        print("🚀 Iniciando regeneración de códigos QR...")
        
        # Obtener todos los equipos activos
        equipos = Equipo.query.filter_by(Estado='activo').all()
        print(f"📋 Encontrados {len(equipos)} equipos activos")
        
        qr_generados = 0
        errores = 0
        
        for equipo in equipos:
            print(f"\n--- Procesando equipo {equipo.IdEquipo} ({equipo.Placa}) ---")
            
            qr_path = generar_qr_equipo(equipo.IdEquipo, equipo.Placa)
            if qr_path:
                qr_generados += 1
                print(f"✅ QR generado exitosamente")
            else:
                errores += 1
                print(f"❌ Error generando QR")
        
        print(f"\n📊 Resumen:")
        print(f"✅ QR generados exitosamente: {qr_generados}")
        print(f"❌ Errores: {errores}")
        print(f"📋 Total equipos procesados: {len(equipos)}")
        
        if errores == 0:
            print("\n🎉 ¡Todos los códigos QR se generaron exitosamente!")
        else:
            print(f"\n⚠️  Se encontraron {errores} errores durante la generación")

if __name__ == "__main__":
    main()

