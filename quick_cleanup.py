#!/usr/bin/env python3
"""
Script rápido para limpiar datos específicos de la base de datos
Uso: python3 quick_cleanup.py [opciones]
"""

import os
import sys
import argparse
from datetime import datetime

# Agregar el directorio del proyecto al path
sys.path.insert(0, '/home/mauricio/apps/flask_app')

from app import app, db
from models import User, TipoEquipo, Marca, EstadoEquipo, Cargo, Cliente, RegistroHoras, Equipo

def cleanup_equipos():
    """Elimina solo los equipos"""
    with app.app_context():
        count = Equipo.query.count()
        if count > 0:
            Equipo.query.delete()
            db.session.commit()
            print(f"✅ {count} equipos eliminados")
        else:
            print("ℹ️  No hay equipos para eliminar")

def cleanup_registros():
    """Elimina solo los registros de horas"""
    with app.app_context():
        count = RegistroHoras.query.count()
        if count > 0:
            RegistroHoras.query.delete()
            db.session.commit()
            print(f"✅ {count} registros de horas eliminados")
        else:
            print("ℹ️  No hay registros de horas para eliminar")

def cleanup_clientes():
    """Elimina solo los clientes"""
    with app.app_context():
        count = Cliente.query.count()
        if count > 0:
            Cliente.query.delete()
            db.session.commit()
            print(f"✅ {count} clientes eliminados")
        else:
            print("ℹ️  No hay clientes para eliminar")

def cleanup_all_operational():
    """Elimina todos los datos operativos y reinicializa cargos"""
    with app.app_context():
        # Eliminar en orden para respetar foreign keys
        registros_count = RegistroHoras.query.count()
        equipos_count = Equipo.query.count()
        clientes_count = Cliente.query.count()
        
        if registros_count > 0:
            RegistroHoras.query.delete()
            print(f"✅ {registros_count} registros de horas eliminados")
        
        if equipos_count > 0:
            Equipo.query.delete()
            print(f"✅ {equipos_count} equipos eliminados")
        
        if clientes_count > 0:
            Cliente.query.delete()
            print(f"✅ {clientes_count} clientes eliminados")
        
        # Reinicializar cargos
        print("🔄 Reinicializando cargos...")
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
        
        print(f"✅ {len(cargos_requeridos)} cargos reinicializados")
        
        if registros_count == 0 and equipos_count == 0 and clientes_count == 0:
            print("ℹ️  No hay datos operativos para eliminar")
        
        db.session.commit()
        print("✅ Limpieza y reinicialización completada")

def show_status():
    """Muestra el estado actual de la base de datos"""
    with app.app_context():
        print("📊 Estado actual de la base de datos:")
        print("=" * 40)
        print(f"Usuarios: {User.query.count()}")
        print(f"Tipos de equipos: {TipoEquipo.query.count()}")
        print(f"Marcas: {Marca.query.count()}")
        print(f"Estados de equipos: {EstadoEquipo.query.count()}")
        print(f"Cargos: {Cargo.query.count()}")
        print(f"Equipos: {Equipo.query.count()}")
        print(f"Registros de horas: {RegistroHoras.query.count()}")
        print(f"Clientes: {Cliente.query.count()}")
        print("=" * 40)

def main():
    parser = argparse.ArgumentParser(description='Script de limpieza rápida de base de datos')
    parser.add_argument('--equipos', action='store_true', help='Eliminar solo equipos')
    parser.add_argument('--registros', action='store_true', help='Eliminar solo registros de horas')
    parser.add_argument('--clientes', action='store_true', help='Eliminar solo clientes')
    parser.add_argument('--all', action='store_true', help='Eliminar todos los datos operativos')
    parser.add_argument('--status', action='store_true', help='Mostrar estado actual')
    
    args = parser.parse_args()
    
    if args.status:
        show_status()
    elif args.equipos:
        cleanup_equipos()
    elif args.registros:
        cleanup_registros()
    elif args.clientes:
        cleanup_clientes()
    elif args.all:
        cleanup_all_operational()
    else:
        print("❌ Debes especificar una opción. Usa --help para ver las opciones disponibles.")

if __name__ == "__main__":
    main()
