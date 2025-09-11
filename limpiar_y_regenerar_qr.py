#!/usr/bin/env python3
"""
Script para limpiar todos los QR antiguos y regenerar con las URLs correctas
"""

import os
import sys
import glob

# Agregar el directorio del proyecto al path
sys.path.insert(0, '/home/mauricio/apps/flask_app')

from app import app, db
from models import Equipo

def limpiar_qr_antiguos():
    """Limpia todos los archivos QR antiguos"""
    qr_dir = os.path.join(app.static_folder, 'qr_codes')
    qr_prod_dir = '/var/www/gruas/static/qr_codes'
    
    print("🧹 Limpiando QR antiguos...")
    
    # Limpiar QR locales
    if os.path.exists(qr_dir):
        qr_files = glob.glob(os.path.join(qr_dir, 'qr_equipo_*.png'))
        for qr_file in qr_files:
            try:
                os.remove(qr_file)
                print(f"   🗑️  Eliminado: {os.path.basename(qr_file)}")
            except Exception as e:
                print(f"   ❌ Error eliminando {qr_file}: {str(e)}")
    
    # Limpiar QR de producción
    if os.path.exists(qr_prod_dir):
        qr_files = glob.glob(os.path.join(qr_prod_dir, 'qr_equipo_*.png'))
        for qr_file in qr_files:
            try:
                os.remove(qr_file)
                print(f"   🗑️  Eliminado (prod): {os.path.basename(qr_file)}")
            except Exception as e:
                print(f"   ❌ Error eliminando {qr_file}: {str(e)}")

def regenerar_todos_qr():
    """Regenera todos los QR con URLs correctas"""
    with app.app_context():
        try:
            print("\n🔄 Regenerando todos los QR...")
            
            # Obtener todos los equipos activos
            equipos = Equipo.query.filter_by(Estado='activo').all()
            
            if not equipos:
                print("ℹ️  No hay equipos activos")
                return True
            
            print(f"📋 Encontrados {len(equipos)} equipos activos")
            
            # Importar función de generación
            from app import generar_qr_equipo
            
            success_count = 0
            
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
                        
                except Exception as e:
                    print(f"      ❌ Error con {equipo.Placa}: {str(e)}")
            
            # Sincronizar con producción
            print("\n🔄 Sincronizando con producción...")
            for equipo in equipos:
                try:
                    qr_filename = f"qr_equipo_{equipo.IdEquipo}_{equipo.Placa}.png"
                    local_path = os.path.join(app.static_folder, 'qr_codes', qr_filename)
                    prod_path = os.path.join('/var/www/gruas/static/qr_codes', qr_filename)
                    
                    if os.path.exists(local_path):
                        os.system(f"sudo cp {local_path} {prod_path}")
                        os.system(f"sudo chown www-data:www-data {prod_path}")
                        os.system(f"sudo chmod 644 {prod_path}")
                        print(f"      ✅ Sincronizado: {qr_filename}")
                    
                except Exception as e:
                    print(f"      ❌ Error sincronizando {equipo.Placa}: {str(e)}")
            
            print(f"\n📊 Resumen:")
            print(f"   ✅ QR generados: {success_count}")
            print(f"   📋 Total equipos: {len(equipos)}")
            
            return True
            
        except Exception as e:
            print(f"❌ Error general: {str(e)}")
            return False

def main():
    """Función principal"""
    print("🔧 Limpiador y Regenerador de Códigos QR")
    print("=" * 50)
    
    # Verificar directorio
    if not os.path.exists('/home/mauricio/apps/flask_app/app.py'):
        print("❌ Error: No se encontró la aplicación Flask")
        sys.exit(1)
    
    # Limpiar QR antiguos
    limpiar_qr_antiguos()
    
    # Regenerar todos los QR
    if regenerar_todos_qr():
        print("\n🎉 ¡Proceso completado exitosamente!")
        print("✅ Todos los QR han sido regenerados con URLs correctas")
        print("🔗 Los QR ahora apuntan a: /equipo/{id}")
    else:
        print("\n❌ Error durante el proceso")

if __name__ == "__main__":
    main()

