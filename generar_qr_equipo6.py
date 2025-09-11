#!/usr/bin/env python3
"""
Script para generar QR específico del equipo 6
"""

import os
import qrcode
from PIL import Image

def generar_qr_equipo6():
    """Genera QR para el equipo 6"""
    try:
        # Crear directorio si no existe
        qr_dir = 'static/qr_codes'
        if not os.path.exists(qr_dir):
            os.makedirs(qr_dir)
            print(f"📁 Directorio creado: {qr_dir}")
        
        # URL del panel del equipo 6
        url_panel = "https://gestor.gruascranes.com/equipo/6"
        
        print(f"🔍 Generando QR para equipo 6")
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
        filename = "qr_equipo_6_mmr323.png"
        filepath = os.path.join(qr_dir, filename)
        img.save(filepath)
        
        print(f"✅ QR guardado en {filepath}")
        
        # Verificar que el archivo existe
        if os.path.exists(filepath):
            file_size = os.path.getsize(filepath)
            print(f"✅ Archivo verificado: {file_size} bytes")
            print(f"✅ Ruta completa: {os.path.abspath(filepath)}")
            return True
        else:
            print(f"❌ Error: Archivo no encontrado después de guardar")
            return False
            
    except Exception as e:
        print(f"❌ Error generando QR: {str(e)}")
        return False

if __name__ == "__main__":
    print("🚀 Generando QR para equipo 6...")
    success = generar_qr_equipo6()
    if success:
        print("🎉 ¡QR generado exitosamente!")
    else:
        print("❌ Error generando QR")

