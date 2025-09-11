#!/usr/bin/env python3
"""
Script para reinicializar solo los cargos con los datos específicos requeridos
"""

import os
import sys

# Agregar el directorio del proyecto al path
sys.path.insert(0, '/home/mauricio/apps/flask_app')

from app import app, db
from models import Cargo

def reset_cargos():
    """Reinicializa los cargos con los datos específicos"""
    cargos_requeridos = [
        {"codigo": "01", "descripcion": "Operador"},
        {"codigo": "02", "descripcion": "Aparejador"},
        {"codigo": "03", "descripcion": "Supervisor"},
        {"codigo": "04", "descripcion": "HSEQ"},
        {"codigo": "05", "descripcion": "Mantenimiento"}
    ]
    
    with app.app_context():
        try:
            print("🔄 Reinicializando cargos...")
            
            # Eliminar todos los cargos existentes
            count_before = Cargo.query.count()
            Cargo.query.delete()
            print(f"   🗑️  {count_before} cargos existentes eliminados")
            
            # Crear los cargos requeridos
            for cargo_data in cargos_requeridos:
                cargo = Cargo(
                    descripcionCargo=cargo_data["descripcion"],
                    Estado='activo'
                )
                db.session.add(cargo)
                print(f"   ✅ {cargo_data['codigo']} - {cargo_data['descripcion']}")
            
            # Confirmar cambios
            db.session.commit()
            
            # Verificar resultado
            count_after = Cargo.query.count()
            print(f"\n✅ Reinicialización completada: {count_after} cargos creados")
            
            # Mostrar cargos finales
            print("\n📊 Cargos finales:")
            cargos = Cargo.query.order_by(Cargo.IdCargo).all()
            for cargo in cargos:
                print(f"   ID: {cargo.IdCargo} - {cargo.descripcionCargo}")
            
            return True
            
        except Exception as e:
            print(f"❌ Error: {str(e)}")
            db.session.rollback()
            return False

if __name__ == "__main__":
    print("🔧 Reinicializador de Cargos - Sistema de Grúas")
    print("=" * 50)
    
    if reset_cargos():
        print("\n🎉 ¡Cargos reinicializados exitosamente!")
    else:
        print("\n❌ Error durante la reinicialización")

