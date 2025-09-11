#!/usr/bin/env python3
"""
Script para inicializar los cargos específicos en la base de datos
Solo mantiene los cargos requeridos: Operador, Aparejador, Supervisor, HSEQ, Mantenimiento
"""

import os
import sys
from datetime import datetime

# Agregar el directorio del proyecto al path
sys.path.insert(0, '/home/mauricio/apps/flask_app')

from app import app, db
from models import Cargo

def get_required_cargos():
    """Retorna la lista de cargos requeridos"""
    return [
        {"codigo": "01", "descripcion": "Operador"},
        {"codigo": "02", "descripcion": "Aparejador"},
        {"codigo": "03", "descripcion": "Supervisor"},
        {"codigo": "04", "descripcion": "HSEQ"},
        {"codigo": "05", "descripcion": "Mantenimiento"}
    ]

def clear_existing_cargos():
    """Elimina todos los cargos existentes"""
    with app.app_context():
        try:
            count = Cargo.query.count()
            if count > 0:
                print(f"🗑️  Eliminando {count} cargos existentes...")
                Cargo.query.delete()
                db.session.commit()
                print(f"✅ {count} cargos eliminados")
            else:
                print("ℹ️  No hay cargos existentes para eliminar")
        except Exception as e:
            print(f"❌ Error eliminando cargos: {str(e)}")
            db.session.rollback()
            return False
    return True

def create_initial_cargos():
    """Crea los cargos iniciales requeridos"""
    cargos_requeridos = get_required_cargos()
    
    with app.app_context():
        try:
            print("📝 Creando cargos iniciales...")
            
            for cargo_data in cargos_requeridos:
                cargo = Cargo(
                    descripcionCargo=cargo_data["descripcion"],
                    Estado='activo'
                )
                db.session.add(cargo)
                print(f"   ✅ {cargo_data['codigo']} - {cargo_data['descripcion']}")
            
            db.session.commit()
            print(f"✅ {len(cargos_requeridos)} cargos creados exitosamente")
            return True
            
        except Exception as e:
            print(f"❌ Error creando cargos: {str(e)}")
            db.session.rollback()
            return False

def show_current_cargos():
    """Muestra los cargos actuales en la base de datos"""
    with app.app_context():
        cargos = Cargo.query.order_by(Cargo.IdCargo).all()
        
        print("\n📊 Cargos actuales en la base de datos:")
        print("=" * 50)
        if cargos:
            for cargo in cargos:
                print(f"ID: {cargo.IdCargo:2d} | {cargo.descripcionCargo:<15} | Estado: {cargo.Estado}")
        else:
            print("No hay cargos en la base de datos")
        print("=" * 50)

def main():
    """Función principal"""
    print("🔧 Inicializador de Cargos - Sistema de Grúas")
    print("=" * 50)
    
    # Verificar que estamos en el directorio correcto
    if not os.path.exists('/home/mauricio/apps/flask_app/app.py'):
        print("❌ Error: No se encontró la aplicación Flask")
        print("   Asegúrate de ejecutar este script desde el directorio correcto")
        sys.exit(1)
    
    # Mostrar cargos requeridos
    cargos_requeridos = get_required_cargos()
    print("📋 Cargos que se crearán:")
    for cargo in cargos_requeridos:
        print(f"   {cargo['codigo']} - {cargo['descripcion']}")
    
    # Mostrar estado actual
    show_current_cargos()
    
    # Confirmar acción
    response = input("\n¿Continuar con la inicialización? (s/N): ")
    if response.lower() not in ['s', 'si', 'sí', 'y', 'yes']:
        print("❌ Operación cancelada")
        return
    
    # Limpiar cargos existentes
    if not clear_existing_cargos():
        print("❌ No se pudo limpiar los cargos existentes")
        return
    
    # Crear cargos iniciales
    if create_initial_cargos():
        print("\n🎉 ¡Inicialización completada exitosamente!")
        show_current_cargos()
        print("\n✅ La base de datos ahora contiene solo los cargos requeridos")
    else:
        print("\n❌ Error durante la inicialización")

if __name__ == "__main__":
    main()

