#!/usr/bin/env python3
"""
Script para regenerar códigos QR con nueva URL de VPS
GRÚAS CRANES S.A.S
"""

import os
import sys
from dotenv import load_dotenv

# Cargar variables de entorno
load_dotenv()

# Agregar el directorio actual al path para importar módulos
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from app import app, db, Equipo, generar_qr_equipo

def regenerar_qr_con_nueva_url():
    """Regenera todos los códigos QR con la nueva URL configurada"""
    
    with app.app_context():
        # Obtener la nueva URL base
        base_url = os.environ.get('BASE_URL')
        if not base_url:
            print("❌ Error: No se encontró BASE_URL en las variables de entorno")
            print("   Configura BASE_URL en tu archivo .env")
            return False
        
        print(f"🔧 Regenerando códigos QR con URL: {base_url}")
        
        # Obtener todos los equipos activos
        equipos = Equipo.query.filter_by(Estado='activo').all()
        
        if not equipos:
            print("⚠️  No se encontraron equipos activos")
            return False
        
        print(f"📋 Encontrados {len(equipos)} equipos activos")
        
        # Regenerar QR para cada equipo
        exitosos = 0
        errores = 0
        
        for equipo in equipos:
            try:
                print(f"🔄 Regenerando QR para {equipo.Placa} (ID: {equipo.IdEquipo})")
                
                # Generar nuevo QR
                qr_path = generar_qr_equipo(equipo.IdEquipo, equipo.Placa)
                
                if qr_path:
                    print(f"   ✅ QR generado: {qr_path}")
                    exitosos += 1
                else:
                    print(f"   ❌ Error generando QR para {equipo.Placa}")
                    errores += 1
                    
            except Exception as e:
                print(f"   ❌ Error procesando {equipo.Placa}: {str(e)}")
                errores += 1
        
        # Resumen
        print(f"\n📊 RESUMEN:")
        print(f"   ✅ Exitosos: {exitosos}")
        print(f"   ❌ Errores: {errores}")
        print(f"   📱 Total: {len(equipos)}")
        
        if exitosos > 0:
            print(f"\n🎉 ¡Códigos QR regenerados exitosamente!")
            print(f"   Nueva URL base: {base_url}")
            print(f"   Los códigos QR ahora apuntan a tu VPS")
        
        return errores == 0

if __name__ == "__main__":
    print("🚀 GRÚAS CRANES S.A.S - Regenerador de Códigos QR")
    print("=" * 50)
    
    # Verificar que existe el archivo .env
    if not os.path.exists('.env'):
        print("⚠️  No se encontró archivo .env")
        print("   Copia env.example como .env y configura BASE_URL")
        sys.exit(1)
    
    # Regenerar códigos QR
    if regenerar_qr_con_nueva_url():
        print("\n✅ Proceso completado exitosamente")
        sys.exit(0)
    else:
        print("\n❌ Proceso completado con errores")
        sys.exit(1)
