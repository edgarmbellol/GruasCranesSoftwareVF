#!/usr/bin/env python3
"""
Script para regenerar códigos QR apuntando al nuevo panel de equipos
"""

import os
import sys

# Agregar el directorio del proyecto al path
sys.path.insert(0, '/home/mauricio/apps/flask_app')

from app import app, db
from models import Equipo

def regenerar_qr_equipos():
    """Regenera códigos QR para todos los equipos activos"""
    with app.app_context():
        try:
            print("🔄 Regenerando códigos QR para equipos...")
            
            # Obtener todos los equipos activos
            equipos = Equipo.query.filter_by(Estado='activo').all()
            
            if not equipos:
                print("ℹ️  No hay equipos activos para regenerar QR")
                return True
            
            print(f"📋 Encontrados {len(equipos)} equipos activos")
            
            # Importar la función de generación de QR
            from app import generar_qr_equipo, sync_to_production
            
            success_count = 0
            error_count = 0
            
            for equipo in equipos:
                try:
                    print(f"   🔄 Generando QR para {equipo.Placa}...")
                    
                    # Generar QR
                    qr_path = generar_qr_equipo(equipo.IdEquipo, equipo.Placa)
                    
                    if qr_path:
                        print(f"      ✅ QR generado: {qr_path}")
                        success_count += 1
                    else:
                        print(f"      ❌ Error generando QR para {equipo.Placa}")
                        error_count += 1
                        
                except Exception as e:
                    print(f"      ❌ Error con {equipo.Placa}: {str(e)}")
                    error_count += 1
            
            # Sincronizar con producción
            print("\n🔄 Sincronizando QR con servidor de producción...")
            try:
                sync_to_production()
                print("✅ Sincronización completada")
            except Exception as e:
                print(f"❌ Error en sincronización: {str(e)}")
            
            print(f"\n📊 Resumen:")
            print(f"   ✅ QR generados exitosamente: {success_count}")
            print(f"   ❌ Errores: {error_count}")
            print(f"   📋 Total equipos: {len(equipos)}")
            
            return error_count == 0
            
        except Exception as e:
            print(f"❌ Error general: {str(e)}")
            return False

def main():
    """Función principal"""
    print("🔧 Regenerador de Códigos QR - Panel de Equipos")
    print("=" * 50)
    
    # Verificar que estamos en el directorio correcto
    if not os.path.exists('/home/mauricio/apps/flask_app/app.py'):
        print("❌ Error: No se encontró la aplicación Flask")
        sys.exit(1)
    
    if regenerar_qr_equipos():
        print("\n🎉 ¡Regeneración completada exitosamente!")
        print("✅ Los códigos QR ahora apuntan al panel de equipos")
    else:
        print("\n❌ Error durante la regeneración")

if __name__ == "__main__":
    main()

