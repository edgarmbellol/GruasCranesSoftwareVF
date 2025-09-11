#!/usr/bin/env python3
"""
Script de inicialización completa de la base de datos
Incluye datos maestros por defecto: cargos, tipos de equipos, marcas, estados
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

def get_initial_cargos():
    """Retorna los cargos iniciales requeridos"""
    return [
        {"codigo": "01", "descripcion": "Operador"},
        {"codigo": "02", "descripcion": "Aparejador"},
        {"codigo": "03", "descripcion": "Supervisor"},
        {"codigo": "04", "descripcion": "HSEQ"},
        {"codigo": "05", "descripcion": "Mantenimiento"}
    ]

def get_initial_tipos_equipos():
    """Retorna los tipos de equipos iniciales"""
    return [
        {"descripcion": "Grúa Torre"},
        {"descripcion": "Grúa Móvil"},
        {"descripcion": "Montacargas"},
        {"descripcion": "Plataforma Elevadora"},
        {"descripcion": "Grúa Telescópica"}
    ]

def get_initial_marcas():
    """Retorna las marcas iniciales"""
    return [
        {"descripcion": "Caterpillar"},
        {"descripcion": "Liebherr"},
        {"descripcion": "Terex"},
        {"descripcion": "Manitowoc"},
        {"descripcion": "Grove"},
        {"descripcion": "Kato"},
        {"descripcion": "Kobelco"}
    ]

def get_initial_estados_equipos():
    """Retorna los estados de equipos iniciales"""
    return [
        {"descripcion": "Operativo"},
        {"descripcion": "Mantenimiento"},
        {"descripcion": "Averiado"},
        {"descripcion": "Fuera de Servicio"},
        {"descripcion": "En Reparación"}
    ]

def clear_table(model_class, table_name):
    """Limpia una tabla específica"""
    with app.app_context():
        try:
            count = model_class.query.count()
            if count > 0:
                print(f"🗑️  Eliminando {count} registros de {table_name}...")
                model_class.query.delete()
                db.session.commit()
                print(f"✅ {count} registros eliminados de {table_name}")
            else:
                print(f"ℹ️  No hay registros en {table_name}")
        except Exception as e:
            print(f"❌ Error eliminando {table_name}: {str(e)}")
            db.session.rollback()
            return False
    return True

def create_initial_data():
    """Crea todos los datos iniciales"""
    with app.app_context():
        try:
            # Crear cargos
            print("📝 Creando cargos iniciales...")
            cargos_data = get_initial_cargos()
            for cargo_data in cargos_data:
                cargo = Cargo(
                    descripcionCargo=cargo_data["descripcion"],
                    Estado='activo'
                )
                db.session.add(cargo)
                print(f"   ✅ {cargo_data['codigo']} - {cargo_data['descripcion']}")
            
            # Crear tipos de equipos
            print("\n📝 Creando tipos de equipos iniciales...")
            tipos_data = get_initial_tipos_equipos()
            for tipo_data in tipos_data:
                tipo = TipoEquipo(
                    descripcion=tipo_data["descripcion"],
                    estado='activo'
                )
                db.session.add(tipo)
                print(f"   ✅ {tipo_data['descripcion']}")
            
            # Crear marcas
            print("\n📝 Creando marcas iniciales...")
            marcas_data = get_initial_marcas()
            for marca_data in marcas_data:
                marca = Marca(
                    DescripcionMarca=marca_data["descripcion"],
                    Estado='activo'
                )
                db.session.add(marca)
                print(f"   ✅ {marca_data['descripcion']}")
            
            # Crear estados de equipos
            print("\n📝 Creando estados de equipos iniciales...")
            estados_data = get_initial_estados_equipos()
            for estado_data in estados_data:
                estado = EstadoEquipo(
                    Descripcion=estado_data["descripcion"],
                    Estado='activo'
                )
                db.session.add(estado)
                print(f"   ✅ {estado_data['descripcion']}")
            
            # Confirmar todos los cambios
            db.session.commit()
            print("\n✅ Todos los datos iniciales creados exitosamente")
            return True
            
        except Exception as e:
            print(f"\n❌ Error creando datos iniciales: {str(e)}")
            db.session.rollback()
            return False

def show_summary():
    """Muestra un resumen de los datos creados"""
    with app.app_context():
        print("\n📊 Resumen de datos iniciales:")
        print("=" * 50)
        print(f"Cargos: {Cargo.query.count()}")
        print(f"Tipos de equipos: {TipoEquipo.query.count()}")
        print(f"Marcas: {Marca.query.count()}")
        print(f"Estados de equipos: {EstadoEquipo.query.count()}")
        print(f"Usuarios: {User.query.count()}")
        print("=" * 50)

def main():
    """Función principal"""
    print("🔧 Inicializador de Base de Datos - Sistema de Grúas")
    print("=" * 60)
    
    # Verificar que estamos en el directorio correcto
    if not os.path.exists('/home/mauricio/apps/flask_app/app.py'):
        print("❌ Error: No se encontró la aplicación Flask")
        print("   Asegúrate de ejecutar este script desde el directorio correcto")
        sys.exit(1)
    
    print("📋 Datos que se crearán:")
    print("   • Cargos: Operador, Aparejador, Supervisor, HSEQ, Mantenimiento")
    print("   • Tipos de equipos: Grúa Torre, Grúa Móvil, Montacargas, etc.")
    print("   • Marcas: Caterpillar, Liebherr, Terex, etc.")
    print("   • Estados: Operativo, Mantenimiento, Averiado, etc.")
    
    # Confirmar acción
    response = input("\n¿Continuar con la inicialización? (s/N): ")
    if response.lower() not in ['s', 'si', 'sí', 'y', 'yes']:
        print("❌ Operación cancelada")
        return
    
    # Limpiar datos maestros existentes
    print("\n🧹 Limpiando datos maestros existentes...")
    tables_to_clear = [
        (Cargo, "cargos"),
        (TipoEquipo, "tipos de equipos"),
        (Marca, "marcas"),
        (EstadoEquipo, "estados de equipos")
    ]
    
    for model_class, table_name in tables_to_clear:
        if not clear_table(model_class, table_name):
            print(f"❌ No se pudo limpiar {table_name}")
            return
    
    # Crear datos iniciales
    if create_initial_data():
        print("\n🎉 ¡Inicialización completada exitosamente!")
        show_summary()
        print("\n✅ La base de datos está lista con los datos maestros iniciales")
        print("🔄 Puedes reiniciar la aplicación con: sudo systemctl restart gruas")
    else:
        print("\n❌ Error durante la inicialización")

if __name__ == "__main__":
    main()

