#!/usr/bin/env python3
"""
Script simple para regenerar códigos QR en VPS
GRÚAS CRANES S.A.S
"""

import os
import sys
from dotenv import load_dotenv

# Cargar variables de entorno
load_dotenv()

# Agregar el directorio actual al path
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from app import app, db, Equipo, generar_qr_equipo

def regenerar_todos_qr():
    """Regenera todos los códigos QR"""
    
    with app.app_context():
        print("🚀 REGENERANDO CÓDIGOS QR - GRÚAS CRANES S.A.S")
        print("=" * 50)
        
        # Verificar BASE_URL
        base_url = os.environ.get('BASE_URL')
        if not base_url:
            print("❌ ERROR: BASE_URL no configurada en .env")
            print("💡 Configura BASE_URL=https://tu-dominio.com en tu archivo .env")
            return False
        
        print(f"✅ BASE_URL: {base_url}")
        
        # Obtener equipos activos
        equipos = Equipo.query.filter_by(Estado='activo').all()
        print(f"📋 Equipos activos: {len(equipos)}")
        
        if not equipos:
            print("❌ No hay equipos activos")
            return False
        
        # Crear directorio QR si no existe
        qr_dir = os.path.join(app.static_folder, 'qr_codes')
        os.makedirs(qr_dir, exist_ok=True)
        print(f"📁 Directorio QR: {qr_dir}")
        
        # Regenerar QR para cada equipo
        exitosos = 0
        errores = 0
        
        for equipo in equipos:
            print(f"\n🔄 Procesando {equipo.Placa} (ID: {equipo.IdEquipo})...")
            
            try:
                qr_path = generar_qr_equipo(equipo.IdEquipo, equipo.Placa)
                if qr_path:
                    print(f"   ✅ QR generado: {qr_path}")
                    exitosos += 1
                else:
                    print(f"   ❌ Error generando QR")
                    errores += 1
            except Exception as e:
                print(f"   ❌ Error: {str(e)}")
                errores += 1
        
        # Resumen
        print(f"\n📊 RESUMEN:")
        print(f"   ✅ Exitosos: {exitosos}")
        print(f"   ❌ Errores: {errores}")
        print(f"   📱 Total: {len(equipos)}")
        
        if exitosos > 0:
            print(f"\n🎉 ¡Códigos QR regenerados exitosamente!")
            print(f"🔗 Accede a: {base_url}/qr-equipos")
            return True
        else:
            print(f"\n❌ No se pudieron generar códigos QR")
            return False

if __name__ == "__main__":
    if regenerar_todos_qr():
        print("\n✅ Proceso completado exitosamente")
        sys.exit(0)
    else:
        print("\n❌ Proceso falló")
        sys.exit(1)
