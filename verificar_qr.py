#!/usr/bin/env python3
"""
Script para verificar qué URL contiene un QR específico
"""

import os
import sys
import qrcode
from PIL import Image
import io

# Agregar el directorio del proyecto al path
sys.path.insert(0, '/home/mauricio/apps/flask_app')

def verificar_qr_local():
    """Verifica el QR local"""
    qr_path = '/home/mauricio/apps/flask_app/static/qr_codes/qr_equipo_3_ytp159.png'
    
    if os.path.exists(qr_path):
        print(f"📱 Verificando QR local: {qr_path}")
        
        # Leer la imagen
        img = Image.open(qr_path)
        
        # Crear un QR temporal para comparar
        from app import app, db
        from models import Equipo
        
        with app.app_context():
            equipo = Equipo.query.filter_by(Estado='activo').first()
            if equipo:
                base_url = os.environ.get('BASE_URL', 'https://gestor.gruascranes.com')
                url_correcta = f"{base_url}/equipo/{equipo.IdEquipo}"
                print(f"✅ URL correcta debería ser: {url_correcta}")
                
                # Generar QR de prueba
                qr_test = qrcode.QRCode(version=1, error_correction=qrcode.constants.ERROR_CORRECT_L, box_size=10, border=4)
                qr_test.add_data(url_correcta)
                qr_test.make(fit=True)
                
                # Comparar tamaños
                img_test = qr_test.make_image(fill_color="black", back_color="white")
                
                print(f"📏 Tamaño QR local: {img.size}")
                print(f"📏 Tamaño QR correcto: {img_test.size}")
                
                if img.size == img_test.size:
                    print("✅ Los tamaños coinciden - QR parece correcto")
                else:
                    print("❌ Los tamaños no coinciden - QR puede estar incorrecto")
            else:
                print("❌ No hay equipos activos")
    else:
        print("❌ QR local no encontrado")

def verificar_qr_produccion():
    """Verifica el QR de producción"""
    qr_path = '/var/www/gruas/static/qr_codes/qr_equipo_3_ytp159.png'
    
    if os.path.exists(qr_path):
        print(f"🌐 Verificando QR de producción: {qr_path}")
        
        # Leer la imagen
        img = Image.open(qr_path)
        print(f"📏 Tamaño QR producción: {img.size}")
        
        # Verificar fecha de modificación
        import time
        mod_time = os.path.getmtime(qr_path)
        mod_date = time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(mod_time))
        print(f"📅 Fecha de modificación: {mod_date}")
        
    else:
        print("❌ QR de producción no encontrado")

def main():
    """Función principal"""
    print("🔍 Verificador de Códigos QR")
    print("=" * 40)
    
    verificar_qr_local()
    print()
    verificar_qr_produccion()
    
    print("\n💡 Recomendaciones:")
    print("1. Limpia el caché de tu navegador")
    print("2. Usa un lector QR diferente")
    print("3. Verifica que estés escaneando el QR correcto")
    print("4. La URL correcta debería ser: https://gestor.gruascranes.com/equipo/3")

if __name__ == "__main__":
    main()

