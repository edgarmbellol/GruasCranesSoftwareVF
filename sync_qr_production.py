#!/usr/bin/env python3
"""
Script para sincronizar códigos QR entre desarrollo y producción
GRÚAS CRANES S.A.S
"""

import os
import shutil
import sys
from pathlib import Path

def sync_qr_to_production():
    """Sincroniza archivos QR del directorio de desarrollo al de producción"""
    
    # Directorios
    dev_dir = Path("/home/mauricio/apps/flask_app/static/qr_codes")
    prod_dir = Path("/var/www/gruas/static/qr_codes")
    
    print("🔄 SINCRONIZANDO CÓDIGOS QR A PRODUCCIÓN")
    print("=" * 50)
    
    # Verificar que existe el directorio de desarrollo
    if not dev_dir.exists():
        print(f"❌ Error: Directorio de desarrollo no existe: {dev_dir}")
        return False
    
    # Crear directorio de producción si no existe
    prod_dir.mkdir(parents=True, exist_ok=True)
    print(f"📁 Directorio de producción: {prod_dir}")
    
    # Obtener archivos QR del directorio de desarrollo
    qr_files = list(dev_dir.glob("qr_equipo_*.png"))
    print(f"📋 Archivos QR encontrados: {len(qr_files)}")
    
    if not qr_files:
        print("⚠️  No se encontraron archivos QR para sincronizar")
        return False
    
    # Sincronizar cada archivo
    sincronizados = 0
    errores = 0
    
    for qr_file in qr_files:
        try:
            # Ruta de destino
            dest_file = prod_dir / qr_file.name
            
            # Copiar archivo
            shutil.copy2(qr_file, dest_file)
            
            # Cambiar permisos
            os.chown(dest_file, 33, 33)  # www-data:www-data
            os.chmod(dest_file, 0o644)
            
            print(f"   ✅ {qr_file.name}")
            sincronizados += 1
            
        except Exception as e:
            print(f"   ❌ Error copiando {qr_file.name}: {e}")
            errores += 1
    
    # Resumen
    print(f"\n📊 RESUMEN:")
    print(f"   ✅ Sincronizados: {sincronizados}")
    print(f"   ❌ Errores: {errores}")
    
    if sincronizados > 0:
        print(f"\n🎉 ¡Sincronización completada!")
        print(f"🌐 Los códigos QR están disponibles en: https://gestor.gruascranes.com/qr_codes/")
        return True
    else:
        print(f"\n❌ No se pudo sincronizar ningún archivo")
        return False

def clean_old_qr():
    """Limpia archivos QR obsoletos del directorio de producción"""
    
    prod_dir = Path("/var/www/gruas/static/qr_codes")
    
    if not prod_dir.exists():
        return
    
    print("\n🧹 LIMPIANDO ARCHIVOS QR OBSOLETOS")
    print("=" * 40)
    
    # Obtener archivos QR en producción
    qr_files = list(prod_dir.glob("qr_equipo_*.png"))
    
    # Agrupar por equipo (ID)
    equipos = {}
    for qr_file in qr_files:
        # Extraer ID del equipo del nombre del archivo
        parts = qr_file.stem.split('_')
        if len(parts) >= 3:
            equipo_id = parts[2]  # qr_equipo_{ID}_{placa}
            
            if equipo_id not in equipos:
                equipos[equipo_id] = []
            equipos[equipo_id].append(qr_file)
    
    # Para cada equipo, mantener solo el archivo más reciente
    eliminados = 0
    for equipo_id, files in equipos.items():
        if len(files) > 1:
            # Ordenar por fecha de modificación (más reciente primero)
            files.sort(key=lambda x: x.stat().st_mtime, reverse=True)
            
            # Eliminar archivos duplicados (mantener solo el más reciente)
            for old_file in files[1:]:
                try:
                    old_file.unlink()
                    print(f"   🗑️  Eliminado: {old_file.name}")
                    eliminados += 1
                except Exception as e:
                    print(f"   ❌ Error eliminando {old_file.name}: {e}")
    
    if eliminados > 0:
        print(f"\n✅ Archivos obsoletos eliminados: {eliminados}")
    else:
        print(f"\n✅ No se encontraron archivos obsoletos")

if __name__ == "__main__":
    print("🚀 GRÚAS CRANES S.A.S - Sincronizador de Códigos QR")
    print("=" * 60)
    
    # Verificar permisos
    if os.geteuid() != 0:
        print("❌ Error: Este script debe ejecutarse con sudo")
        print("💡 Uso: sudo python3 sync_qr_production.py")
        sys.exit(1)
    
    # Sincronizar archivos
    if sync_qr_to_production():
        # Limpiar archivos obsoletos
        clean_old_qr()
        print("\n✅ Proceso completado exitosamente")
        sys.exit(0)
    else:
        print("\n❌ Proceso completado con errores")
        sys.exit(1)
