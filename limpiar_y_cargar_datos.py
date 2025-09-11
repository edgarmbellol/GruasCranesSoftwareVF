#!/usr/bin/env python3
"""
Script para limpiar todas las tablas y cargar datos maestros específicos
"""

import os
import sys
import random
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
    print("⚠️  ADVERTENCIA: Este script eliminará TODOS los datos de la base de datos.")
    print("📋 Datos que se CARGARÁN:")
    print("   - Tipos de equipos: Grúa Móvil, Grúa Torre")
    print("   - Cliente: Grúas Cranes (con NIT aleatorio)")
    print("   - Marcas: Se mantienen las existentes")
    print("   - Cargos: Operador, Aparejador, Supervisor, HSEQ, Mantenimiento")
    print("   - Estados de equipos: Operativo, Fuera de servicio, Mantenimiento, Averiado")
    print()
    print("🗑️  Datos que se ELIMINARÁN:")
    print("   - TODOS los datos existentes")
    print("   - Usuarios (incluyendo admin)")
    print("   - Equipos")
    print("   - Registros de horas")
    print("   - Clientes existentes")
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

def print_table_counts(counts, title="Estado de la base de datos"):
    """Imprime el conteo de registros en formato tabular"""
    print(f"\n📊 {title}:")
    print("=" * 60)
    print(f"{'Tabla':<20} {'Registros':<10} {'Estado':<15}")
    print("-" * 60)
    
    for table, count in counts.items():
        status = "✅ CARGADO" if count > 0 else "❌ VACÍO"
        print(f"{table:<20} {count:<10} {status:<15}")
    
    print("=" * 60)

def limpiar_todas_las_tablas():
    """Limpia todas las tablas de la base de datos"""
    print("🧹 Limpiando todas las tablas...")
    
    with app.app_context():
        try:
            # Eliminar en orden para respetar foreign keys
            print("   🗑️  Eliminando registros de horas...")
            deleted_horas = RegistroHoras.query.delete()
            print(f"      ✅ {deleted_horas} registros de horas eliminados")
            
            print("   🗑️  Eliminando equipos...")
            deleted_equipos = Equipo.query.delete()
            print(f"      ✅ {deleted_equipos} equipos eliminados")
            
            print("   🗑️  Eliminando clientes...")
            deleted_clientes = Cliente.query.delete()
            print(f"      ✅ {deleted_clientes} clientes eliminados")
            
            print("   🗑️  Eliminando usuarios...")
            deleted_usuarios = User.query.delete()
            print(f"      ✅ {deleted_usuarios} usuarios eliminados")
            
            print("   🗑️  Eliminando tipos de equipos...")
            deleted_tipos = TipoEquipo.query.delete()
            print(f"      ✅ {deleted_tipos} tipos de equipos eliminados")
            
            print("   🗑️  Eliminando estados de equipos...")
            deleted_estados = EstadoEquipo.query.delete()
            print(f"      ✅ {deleted_estados} estados de equipos eliminados")
            
            print("   🗑️  Eliminando cargos...")
            deleted_cargos = Cargo.query.delete()
            print(f"      ✅ {deleted_cargos} cargos eliminados")
            
            # Las marcas se mantienen según lo solicitado
            print("   ✅ Marcas mantenidas (no se eliminan)")
            
            db.session.commit()
            print("   ✅ Limpieza completada")
            
        except Exception as e:
            print(f"   ❌ Error durante la limpieza: {str(e)}")
            db.session.rollback()
            return False
    
    return True

def cargar_datos_maestros():
    """Carga los datos maestros específicos"""
    print("📥 Cargando datos maestros...")
    
    with app.app_context():
        try:
            # 1. Tipos de equipos
            print("   📋 Cargando tipos de equipos...")
            tipos_equipos = [
                {"descripcion": "Grúa Móvil", "estado": "activo"},
                {"descripcion": "Grúa Torre", "estado": "activo"}
            ]
            
            for tipo_data in tipos_equipos:
                tipo = TipoEquipo(
                    descripcion=tipo_data["descripcion"],
                    estado=tipo_data["estado"]
                )
                db.session.add(tipo)
            
            print(f"      ✅ {len(tipos_equipos)} tipos de equipos cargados")
            
            # 2. Estados de equipos
            print("   🔧 Cargando estados de equipos...")
            estados_equipos = [
                {"descripcion": "Operativo", "estado": "activo"},
                {"descripcion": "Fuera de servicio", "estado": "activo"},
                {"descripcion": "Mantenimiento", "estado": "activo"},
                {"descripcion": "Averiado", "estado": "activo"}
            ]
            
            for estado_data in estados_equipos:
                estado = EstadoEquipo(
                    Descripcion=estado_data["descripcion"],
                    Estado=estado_data["estado"]
                )
                db.session.add(estado)
            
            print(f"      ✅ {len(estados_equipos)} estados de equipos cargados")
            
            # 4. Cargos
            print("   👥 Cargando cargos...")
            cargos = [
                {"codigo": "01", "descripcion": "Operador"},
                {"codigo": "02", "descripcion": "Aparejador"},
                {"codigo": "03", "descripcion": "Supervisor"},
                {"codigo": "04", "descripcion": "HSEQ"},
                {"codigo": "05", "descripcion": "Mantenimiento"}
            ]
            
            for cargo_data in cargos:
                cargo = Cargo(
                    descripcionCargo=cargo_data["descripcion"],
                    Estado="activo"
                )
                db.session.add(cargo)
            
            print(f"      ✅ {len(cargos)} cargos cargados")
            
            # 5. Usuario administrador
            print("   👤 Creando usuario administrador...")
            
            admin_user = User(
                tipo_documento="CC",
                documento="admin",
                nombre="Administrador",
                email="admin@gruascranes.com",
                celular="3001234567",
                contrasena="admin123",
                perfil_usuario="administrador"
            )
            db.session.add(admin_user)
            db.session.flush()  # Flush para obtener el ID sin hacer commit
            print("      ✅ Usuario administrador creado (usuario: admin, contraseña: admin123)")
            
            # 5. Cliente (después del usuario admin)
            print("   🏢 Cargando cliente...")
            nit_aleatorio = f"{random.randint(80000000, 99999999)}-{random.randint(1, 9)}"
            
            cliente = Cliente(
                NombreCliente="Grúas Cranes",
                Nit=nit_aleatorio,
                UsuarioCrea=admin_user.id,
                Estado="activo"
            )
            db.session.add(cliente)
            print(f"      ✅ Cliente 'Grúas Cranes' cargado (NIT: {nit_aleatorio})")
            
            # Confirmar cambios
            db.session.commit()
            print("   ✅ Datos maestros cargados exitosamente")
            
        except Exception as e:
            print(f"   ❌ Error cargando datos maestros: {str(e)}")
            db.session.rollback()
            return False
    
    return True

def main():
    """Función principal"""
    print("🔧 Script de Limpieza y Carga de Datos - Sistema de Grúas")
    print("=" * 70)
    
    # Verificar que estamos en el directorio correcto
    if not os.path.exists('/home/mauricio/apps/flask_app/app.py'):
        print("❌ Error: No se encontró la aplicación Flask")
        print("   Asegúrate de ejecutar este script desde el directorio correcto")
        sys.exit(1)
    
    # Mostrar estado actual
    print("📊 Verificando estado actual de la base de datos...")
    initial_counts = get_table_counts()
    print_table_counts(initial_counts, "Estado ANTES de la limpieza")
    
    # Solicitar confirmación
    if not confirm_action():
        print("❌ Operación cancelada por el usuario")
        return
    
    # Realizar limpieza
    if not limpiar_todas_las_tablas():
        print("❌ Error durante la limpieza. Abortando operación.")
        return
    
    # Cargar datos maestros
    if not cargar_datos_maestros():
        print("❌ Error cargando datos maestros. Abortando operación.")
        return
    
    print("\n🎉 ¡Proceso completado exitosamente!")
    
    # Mostrar estado final
    final_counts = get_table_counts()
    print_table_counts(final_counts, "Estado DESPUÉS de la carga")
    
    print("\n✅ La base de datos ha sido limpiada y cargada con los datos maestros.")
    print("🔄 Reinicia la aplicación con: sudo systemctl restart gruas")
    print("🔑 Usuario administrador: admin / admin123")

if __name__ == "__main__":
    main()
