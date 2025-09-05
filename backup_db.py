#!/usr/bin/env python3
"""
Script para hacer backup y restore de la base de datos
"""

import os
import shutil
from datetime import datetime

def backup_database():
    """Crear backup de la base de datos"""
    db_path = "instance/gruas_cranes.db"
    if not os.path.exists(db_path):
        print("❌ No se encontró la base de datos")
        return
    
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    backup_path = f"backups/gruas_cranes_backup_{timestamp}.db"
    
    # Crear directorio de backups si no existe
    os.makedirs("backups", exist_ok=True)
    
    # Copiar la base de datos
    shutil.copy2(db_path, backup_path)
    print(f"✅ Backup creado: {backup_path}")
    return backup_path

def restore_database(backup_file):
    """Restaurar base de datos desde backup"""
    if not os.path.exists(backup_file):
        print(f"❌ No se encontró el archivo de backup: {backup_file}")
        return
    
    db_path = "instance/gruas_cranes.db"
    
    # Crear directorio instance si no existe
    os.makedirs("instance", exist_ok=True)
    
    # Restaurar la base de datos
    shutil.copy2(backup_file, db_path)
    print(f"✅ Base de datos restaurada desde: {backup_file}")

if __name__ == "__main__":
    import sys
    
    if len(sys.argv) < 2:
        print("Uso:")
        print("  python backup_db.py backup          # Crear backup")
        print("  python backup_db.py restore <file>  # Restaurar desde backup")
        sys.exit(1)
    
    command = sys.argv[1]
    
    if command == "backup":
        backup_database()
    elif command == "restore":
        if len(sys.argv) < 3:
            print("❌ Especifica el archivo de backup")
            sys.exit(1)
        restore_database(sys.argv[2])
    else:
        print("❌ Comando no válido")
        sys.exit(1)
