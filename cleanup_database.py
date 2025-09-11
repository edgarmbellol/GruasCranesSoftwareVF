#!/usr/bin/env python3
"""
Script para limpiar la base de datos manteniendo solo los datos maestros
Mantiene: tipos de equipos, marcas, estados de equipos, cargos, usuarios
Elimina: equipos, registros de horas, clientes
"""

import os
import sys
from datetime import datetime

# Agregar el directorio del proyecto al path
sys.path.insert(0, '/home/mauricio/apps/flask_app')

from app import app, db
from models import (
    User, TipoEquipo, Marca, EstadoEquipo, Cargo, 
    Cliente, RegistroHoras, Equipo
)

def confirm_action():
    """Solicita confirmación del usuario"""
    print("⚠️  ADVERTENCIA: Este script eliminará TODOS los datos operativos de la base de datos.")
    print("📋 Datos que se MANTENDRÁN (datos maestros):")
    print("   - Tipos de equipos")
    print("   - Marcas de equipos")
    print("   - Estados de equipos")
    print("   - Cargos de empleados")
    print("   - Usuarios (incluyendo admin)")
    print()
    print("🗑️  Datos que se ELIMINARÁN:")
    print("   - Equipos")
    print("   - Registros de horas")
    print("   - Clientes")
    print()
    
    response = input("¿Estás seguro de continuar? Escribe 'SI' para confirmar: ")
    return response.upper() == 'SI'

def get_table_counts():
    """Obtiene el conteo de registros en cada tabla"""
    counts = {}
    
    with app.app_context():
        counts['usuarios'] = User.query.count()
        counts['tipos_equipos'] = TipoEquipo.query.count()
        counts['marcas'] = Marca.query.count()
        counts['estado_equipos'] = EstadoEquipo.query.count()
        counts['cargos'] = Cargo.query.count()
        counts['equipos'] = Equipo.query.count()
        counts['registro_horas'] = RegistroHoras.query.count()
        counts['clientes'] = Cliente.query.count()
    
    return counts

def print_table_counts(counts, title="Estado actual de la base de datos"):
    """Imprime el conteo de registros en formato tabular"""
    print(f"\n📊 {title}:")
    print("=" * 60)
    print(f"{'Tabla':<20} {'Registros':<10} {'Estado':<15}")
    print("-" * 60)
    
    # Datos maestros (se mantienen)
    master_tables = ['usuarios', 'tipos_equipos', 'marcas', 'estado_equipos', 'cargos']
    for table in master_tables:
        count = counts.get(table, 0)
        status = "✅ MANTENER"
        print(f"{table:<20} {count:<10} {status:<15}")
    
    print("-" * 60)
    
    # Datos operativos (se eliminan)
    operational_tables = ['equipos', 'registro_horas', 'clientes']
    for table in operational_tables:
        count = counts.get(table, 0)
        status = "🗑️  ELIMINAR"
        print(f"{table:<20} {count:<10} {status:<15}")
    
    print("=" * 60)

def cleanup_database():
    """Limpia la base de datos eliminando datos operativos"""
    print("🧹 Iniciando limpieza de la base de datos...")
    
    with app.app_context():
        try:
            # Eliminar registros de horas (primero por las foreign keys)
            print("   🗑️  Eliminando registros de horas...")
            deleted_horas = RegistroHoras.query.delete()
            print(f"      ✅ {deleted_horas} registros de horas eliminados")
            
            # Eliminar equipos
            print("   🗑️  Eliminando equipos...")
            deleted_equipos = Equipo.query.delete()
            print(f"      ✅ {deleted_equipos} equipos eliminados")
            
            # Eliminar clientes
            print("   🗑️  Eliminando clientes...")
            deleted_clientes = Cliente.query.delete()
            print(f"      ✅ {deleted_clientes} clientes eliminados")
            
            # Reinicializar cargos con datos específicos
            print("   🔄 Reinicializando cargos...")
            Cargo.query.delete()
            cargos_requeridos = [
                {"codigo": "01", "descripcion": "Operador"},
                {"codigo": "02", "descripcion": "Aparejador"},
                {"codigo": "03", "descripcion": "Supervisor"},
                {"codigo": "04", "descripcion": "HSEQ"},
                {"codigo": "05", "descripcion": "Mantenimiento"}
            ]
            
            for cargo_data in cargos_requeridos:
                cargo = Cargo(
                    descripcionCargo=cargo_data["descripcion"],
                    Estado='activo'
                )
                db.session.add(cargo)
            
            print(f"      ✅ {len(cargos_requeridos)} cargos reinicializados")
            
            # Confirmar cambios
            db.session.commit()
            print("   ✅ Cambios confirmados en la base de datos")
            
        except Exception as e:
            print(f"   ❌ Error durante la limpieza: {str(e)}")
            db.session.rollback()
            return False
    
    return True

def create_backup_info():
    """Crea un archivo con información del backup"""
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    backup_file = f"/home/mauricio/apps/flask_app/backup_info_{timestamp}.txt"
    
    with open(backup_file, 'w') as f:
        f.write(f"Información de Limpieza de Base de Datos\n")
        f.write(f"Fecha: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n")
        f.write(f"Script: cleanup_database.py\n\n")
        
        f.write("Datos eliminados:\n")
        f.write("- Equipos\n")
        f.write("- Registros de horas\n")
        f.write("- Clientes\n\n")
        
        f.write("Datos mantenidos:\n")
        f.write("- Usuarios\n")
        f.write("- Tipos de equipos\n")
        f.write("- Marcas\n")
        f.write("- Estados de equipos\n")
        f.write("- Cargos\n")
    
    print(f"📄 Información de backup guardada en: {backup_file}")

def main():
    """Función principal"""
    print("🔧 Script de Limpieza de Base de Datos - Sistema de Grúas")
    print("=" * 60)
    
    # Verificar que estamos en el directorio correcto
    if not os.path.exists('/home/mauricio/apps/flask_app/app.py'):
        print("❌ Error: No se encontró la aplicación Flask")
        print("   Asegúrate de ejecutar este script desde el directorio correcto")
        sys.exit(1)
    
    # Mostrar estado actual
    print("📊 Verificando estado actual de la base de datos...")
    initial_counts = get_table_counts()
    print_table_counts(initial_counts, "Estado ANTES de la limpieza")
    
    # Verificar si hay datos para eliminar
    total_operational = (initial_counts.get('equipos', 0) + 
                        initial_counts.get('registro_horas', 0) + 
                        initial_counts.get('clientes', 0))
    
    if total_operational == 0:
        print("\n✅ No hay datos operativos para eliminar. La base de datos ya está limpia.")
        return
    
    # Solicitar confirmación
    if not confirm_action():
        print("❌ Operación cancelada por el usuario")
        return
    
    # Crear información de backup
    create_backup_info()
    
    # Realizar limpieza
    if cleanup_database():
        print("\n🎉 ¡Limpieza completada exitosamente!")
        
        # Mostrar estado final
        final_counts = get_table_counts()
        print_table_counts(final_counts, "Estado DESPUÉS de la limpieza")
        
        print("\n✅ La base de datos ha sido limpiada manteniendo solo los datos maestros.")
        print("🔄 Puedes reiniciar la aplicación con: sudo systemctl restart gruas")
        
    else:
        print("\n❌ Error durante la limpieza. Revisa los logs para más detalles.")

if __name__ == "__main__":
    main()
