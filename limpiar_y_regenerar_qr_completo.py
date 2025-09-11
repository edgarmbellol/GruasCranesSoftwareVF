#!/usr/bin/env python3
"""
Script para limpiar y regenerar todos los códigos QR
"""

import os
import sys
import shutil

# Agregar el directorio del proyecto al path
sys.path.insert(0, '/home/mauricio/apps/flask_app')

from app import app, db
from models import Equipo

def limpiar_qr_existentes():
    """Limpiar todos los archivos QR existentes"""
    print("🧹 Limpiando QR existentes...")
    
    # Limpiar QR locales
    qr_local_dir = '/home/mauricio/apps/flask_app/static/qr_codes'
    if os.path.exists(qr_local_dir):
        for archivo in os.listdir(qr_local_dir):
            if archivo.endswith('.png'):
                os.remove(os.path.join(qr_local_dir, archivo))
                print(f"   🗑️  Eliminado local: {archivo}")
    
    # Limpiar QR de producción
    qr_prod_dir = '/var/www/gruas/static/qr_codes'
    if os.path.exists(qr_prod_dir):
        for archivo in os.listdir(qr_prod_dir):
            if archivo.endswith('.png'):
                try:
                    os.remove(os.path.join(qr_prod_dir, archivo))
                    print(f"   🗑️  Eliminado producción: {archivo}")
                except PermissionError:
                    print(f"   ⚠️  Error eliminando {archivo} (permisos)")

def regenerar_todos_qr():
    """Regenerar todos los códigos QR"""
    print("🔄 Regenerando todos los QR...")
    
    with app.app_context():
        equipos = Equipo.query.filter_by(Estado='activo').all()
        
        if not equipos:
            print("   ❌ No hay equipos activos para generar QR")
            return
        
        print(f"   📋 Encontrados {len(equipos)} equipos activos")
        
        for equipo in equipos:
            try:
                from app import generar_qr_equipo
                qr_path = generar_qr_equipo(equipo.IdEquipo, equipo.Placa)
                print(f"   ✅ QR generado para {equipo.Placa}: {qr_path}")
            except Exception as e:
                print(f"   ❌ Error generando QR para {equipo.Placa}: {e}")

def sincronizar_qr_produccion():
    """Sincronizar QR con el servidor de producción"""
    print("🔄 Sincronizando QR con producción...")
    
    qr_local_dir = '/home/mauricio/apps/flask_app/static/qr_codes'
    qr_prod_dir = '/var/www/gruas/static/qr_codes'
    
    if not os.path.exists(qr_local_dir):
        print("   ❌ Directorio local de QR no existe")
        return
    
    for archivo in os.listdir(qr_local_dir):
        if archivo.endswith('.png'):
            try:
                shutil.copy2(
                    os.path.join(qr_local_dir, archivo),
                    os.path.join(qr_prod_dir, archivo)
                )
                os.chmod(os.path.join(qr_prod_dir, archivo), 0o644)
                print(f"   ✅ Sincronizado: {archivo}")
            except Exception as e:
                print(f"   ❌ Error sincronizando {archivo}: {e}")

def main():
    """Función principal"""
    print("🔧 Limpiador y Regenerador de QR Completo")
    print("=" * 45)
    
    # Limpiar QR existentes
    limpiar_qr_existentes()
    
    # Regenerar todos los QR
    regenerar_todos_qr()
    
    # Sincronizar con producción
    sincronizar_qr_produccion()
    
    print("\n🎉 ¡Proceso completado!")
    print("✅ Todos los QR han sido limpiados y regenerados")

if __name__ == "__main__":
    main()

