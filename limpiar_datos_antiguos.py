#!/usr/bin/env python3
"""
Script para limpiar solo los datos antiguos y mantener los correctos
"""

import os
import sys

# Agregar el directorio del proyecto al path
sys.path.insert(0, '/home/mauricio/apps/flask_app')

from app import app, db
from models import (
    User, TipoEquipo, Marca, EstadoEquipo, Cargo, 
    Cliente, RegistroHoras, Equipo
)

def limpiar_datos_antiguos():
    """Limpiar solo los datos antiguos y mantener los correctos"""
    with app.app_context():
        print("🧹 Limpiando datos antiguos...")
        print("=" * 40)
        
        try:
            # Eliminar registros de horas
            print("   🗑️  Eliminando registros de horas...")
            deleted_horas = RegistroHoras.query.delete()
            print(f"      ✅ {deleted_horas} registros de horas eliminados")
            
            # Eliminar equipos
            print("   🗑️  Eliminando equipos...")
            deleted_equipos = Equipo.query.delete()
            print(f"      ✅ {deleted_equipos} equipos eliminados")
            
            # Eliminar usuarios (excepto administrador)
            print("   🗑️  Eliminando usuarios (excepto administrador)...")
            usuarios_antiguos = User.query.filter(User.perfil_usuario != 'administrador').all()
            for usuario in usuarios_antiguos:
                db.session.delete(usuario)
            print(f"      ✅ {len(usuarios_antiguos)} usuarios eliminados")
            
            # Eliminar clientes (excepto Grúas Cranes)
            print("   🗑️  Eliminando clientes antiguos...")
            clientes_antiguos = Cliente.query.filter(Cliente.NombreCliente != 'Grúas Cranes').all()
            for cliente in clientes_antiguos:
                db.session.delete(cliente)
            print(f"      ✅ {len(clientes_antiguos)} clientes antiguos eliminados")
            
            # Limpiar tipos de equipos (dejar solo Grúa Móvil y Grúa Torre)
            print("   🗑️  Limpiando tipos de equipos...")
            tipos_antiguos = TipoEquipo.query.filter(
                ~TipoEquipo.descripcion.in_(['Grúa Móvil', 'Grúa Torre'])
            ).all()
            for tipo in tipos_antiguos:
                db.session.delete(tipo)
            print(f"      ✅ {len(tipos_antiguos)} tipos de equipos antiguos eliminados")
            
            # Limpiar estados de equipos (dejar solo los 4 correctos)
            print("   🗑️  Limpiando estados de equipos...")
            estados_correctos = ['Operativo', 'Fuera de servicio', 'Mantenimiento', 'Averiado']
            estados_antiguos = EstadoEquipo.query.filter(
                ~EstadoEquipo.Descripcion.in_(estados_correctos)
            ).all()
            for estado in estados_antiguos:
                db.session.delete(estado)
            print(f"      ✅ {len(estados_antiguos)} estados de equipos antiguos eliminados")
            
            # Limpiar cargos (dejar solo los 5 correctos)
            print("   🗑️  Limpiando cargos...")
            cargos_correctos = ['Operador', 'Aparejador', 'Supervisor', 'HSEQ', 'Mantenimiento']
            cargos_antiguos = Cargo.query.filter(
                ~Cargo.descripcionCargo.in_(cargos_correctos)
            ).all()
            for cargo in cargos_antiguos:
                db.session.delete(cargo)
            print(f"      ✅ {len(cargos_antiguos)} cargos antiguos eliminados")
            
            # Confirmar cambios
            db.session.commit()
            print("   ✅ Limpieza completada exitosamente")
            
            # Mostrar estado final
            print("\n📊 Estado final de la base de datos:")
            print(f"   👤 Usuarios: {User.query.count()}")
            print(f"   🏗️  Tipos de equipos: {TipoEquipo.query.count()}")
            print(f"   🏢 Marcas: {Marca.query.count()}")
            print(f"   🔧 Estados de equipos: {EstadoEquipo.query.count()}")
            print(f"   👥 Cargos: {Cargo.query.count()}")
            print(f"   🏢 Clientes: {Cliente.query.count()}")
            print(f"   🚛 Equipos: {Equipo.query.count()}")
            print(f"   ⏰ Registros de horas: {RegistroHoras.query.count()}")
            
        except Exception as e:
            print(f"   ❌ Error durante la limpieza: {str(e)}")
            db.session.rollback()
            return False
    
    return True

def main():
    """Función principal"""
    print("🧹 Limpiador de Datos Antiguos")
    print("=" * 30)
    
    if limpiar_datos_antiguos():
        print("\n🎉 ¡Limpieza completada exitosamente!")
        print("✅ Solo quedan los datos maestros correctos")
    else:
        print("\n❌ Error durante la limpieza")

if __name__ == "__main__":
    main()

