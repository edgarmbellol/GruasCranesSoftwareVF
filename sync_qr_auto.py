#!/usr/bin/env python3
"""
Script automático para sincronizar códigos QR con el directorio de producción
Este script se ejecuta periódicamente para sincronizar QR generados por la aplicación
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
        subprocess.run(['sudo', 'mkdir', '-p', target_dir], check=True)
        
        # Establecer permisos del directorio
        subprocess.run(['sudo', 'chown', 'www-data:www-data', target_dir], check=True)
        subprocess.run(['sudo', 'chmod', '755', target_dir], check=True)
        
        # Sincronizar todos los archivos QR
        subprocess.run(['sudo', 'rsync', '-av', '--delete', 
                       f'{source_dir}/', f'{target_dir}/'], check=True)
        
        # Ajustar permisos de todos los archivos
        subprocess.run(['sudo', 'chown', '-R', 'www-data:www-data', target_dir], check=True)
        subprocess.run(['sudo', 'chmod', '-R', '644', target_dir], check=True)
        
        # Limpiar archivo de marcador si existe
        sync_marker = os.path.join(source_dir, '.sync_pending')
        if os.path.exists(sync_marker):
            os.remove(sync_marker)
        
        print("✅ QR sincronizados correctamente con producción")
        return True
        
    except Exception as e:
        print(f"❌ Error sincronizando QR: {e}")
        return False

if __name__ == "__main__":
    print("🔄 Iniciando sincronización automática de QR...")
    success = sync_qr_files()
    if success:
        print("✅ Sincronización completada exitosamente")
        sys.exit(0)
    else:
        print("❌ Error en la sincronización")
        sys.exit(1)
