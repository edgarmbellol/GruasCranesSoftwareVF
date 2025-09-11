#!/usr/bin/env python3
"""
Daemon para sincronizar automáticamente códigos QR con el directorio de producción
Este script se ejecuta con permisos de root y monitorea cambios en los QR
"""

import os
import time
import subprocess
import sys
from pathlib import Path

def sync_qr_files():
    """Sincroniza todos los archivos QR con el directorio de producción"""
    try:
        # Directorios
        source_dir = '/home/mauricio/apps/flask_app/static/qr_codes'
        target_dir = '/var/www/gruas/static/qr_codes'
        
        # Crear directorio de destino si no existe
        subprocess.run(['mkdir', '-p', target_dir], check=True)
        
        # Establecer permisos del directorio
        subprocess.run(['chown', 'www-data:www-data', target_dir], check=True)
        subprocess.run(['chmod', '755', target_dir], check=True)
        
        # Sincronizar todos los archivos QR
        subprocess.run(['rsync', '-av', '--delete', 
                       f'{source_dir}/', f'{target_dir}/'], check=True)
        
        # Ajustar permisos de todos los archivos
        subprocess.run(['chown', '-R', 'www-data:www-data', target_dir], check=True)
        subprocess.run(['chmod', '-R', '644', target_dir], check=True)
        
        # Restaurar permisos de ejecución para el directorio
        subprocess.run(['chmod', '755', target_dir], check=True)
        
        # Limpiar archivo de marcador si existe
        sync_marker = os.path.join(source_dir, '.sync_pending')
        if os.path.exists(sync_marker):
            os.remove(sync_marker)
            print("🧹 Archivo de marcador limpiado")
        
        print("✅ QR sincronizados correctamente con producción")
        return True
        
    except Exception as e:
        print(f"❌ Error sincronizando QR: {e}")
        return False

def monitor_sync_pending():
    """Monitorea el archivo .sync_pending para sincronizar cuando sea necesario"""
    sync_marker = '/home/mauricio/apps/flask_app/static/qr_codes/.sync_pending'
    last_modified = 0
    
    print("🔄 Iniciando monitoreo de sincronización de QR...")
    
    while True:
        try:
            if os.path.exists(sync_marker):
                current_modified = os.path.getmtime(sync_marker)
                if current_modified > last_modified:
                    print("📝 Detectados QR pendientes de sincronización")
                    if sync_qr_files():
                        last_modified = current_modified
                        print("✅ Sincronización completada")
                    else:
                        print("❌ Error en sincronización")
            
            # Esperar 5 segundos antes de verificar nuevamente
            time.sleep(5)
            
        except KeyboardInterrupt:
            print("\n🛑 Deteniendo monitoreo de sincronización...")
            break
        except Exception as e:
            print(f"⚠️  Error en monitoreo: {e}")
            time.sleep(10)

if __name__ == "__main__":
    if len(sys.argv) > 1 and sys.argv[1] == "sync":
        # Modo de sincronización única
        print("🔄 Ejecutando sincronización única...")
        success = sync_qr_files()
        if success:
            print("✅ Sincronización completada exitosamente")
            sys.exit(0)
        else:
            print("❌ Error en la sincronización")
            sys.exit(1)
    else:
        # Modo daemon (monitoreo continuo)
        monitor_sync_pending()
