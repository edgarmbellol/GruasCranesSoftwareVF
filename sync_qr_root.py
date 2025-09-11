#!/usr/bin/env python3
"""
Script para sincronizar códigos QR con el directorio de producción
Este script debe ejecutarse con permisos de root
"""

import os
import subprocess
import sys

def sync_qr_files():
    """Sincroniza todos los archivos QR con el directorio de producción"""
    try:
        # Directorios
        source_dir = '/home/mauricio/apps/flask_app/static/qr_codes'
        target_dir = '/var/www/gruas/static/qr_codes'
        
        # Crear directorio de destino si no existe
        os.makedirs(target_dir, exist_ok=True)
        
        # Establecer permisos del directorio
        os.chown(target_dir, 33, 33)  # www-data user and group
        os.chmod(target_dir, 0o755)
        
        # Asegurar que el directorio tenga permisos de ejecución para todos
        os.chmod(target_dir, 0o755)
        
        # Sincronizar todos los archivos QR
        for filename in os.listdir(source_dir):
            if filename.endswith('.png') and filename.startswith('qr_equipo_'):
                source_path = os.path.join(source_dir, filename)
                target_path = os.path.join(target_dir, filename)
                
                # Copiar archivo
                with open(source_path, 'rb') as src, open(target_path, 'wb') as dst:
                    dst.write(src.read())
                
                # Establecer permisos
                os.chown(target_path, 33, 33)  # www-data user and group
                os.chmod(target_path, 0o644)
                
                print(f"✅ Sincronizado: {filename}")
        
        # Limpiar archivo de marcador si existe
        sync_marker = os.path.join(source_dir, '.sync_pending')
        if os.path.exists(sync_marker):
            os.remove(sync_marker)
            print("🧹 Archivo de marcador limpiado")
        
        print("✅ Todos los QR sincronizados correctamente")
        return True
        
    except Exception as e:
        print(f"❌ Error sincronizando QR: {e}")
        return False

if __name__ == "__main__":
    print("🔄 Iniciando sincronización de QR con permisos de root...")
    success = sync_qr_files()
    if success:
        print("✅ Sincronización completada exitosamente")
        sys.exit(0)
    else:
        print("❌ Error en la sincronización")
        sys.exit(1)
