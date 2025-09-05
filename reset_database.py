#!/usr/bin/env python3
"""
Script de emergencia para resetear completamente la base de datos
Mantiene solo los datos maestros y el usuario administrador
"""

from app import app, db
from models import *
import os
import shutil

def reset_completo():
    """Resetear completamente la base de datos"""
    with app.app_context():
        print("🚨 RESET COMPLETO DE LA BASE DE DATOS")
        print("=" * 50)
        print("⚠️  ADVERTENCIA: Esta acción eliminará TODOS los datos excepto:")
        print("   - Usuario administrador")
        print("   - Datos maestros (tipos, marcas, estados, cargos)")
        print("   - Configuración del sistema")
        print("\nSe eliminarán:")
        print("   - Todos los usuarios (excepto admin)")
        print("   - Todos los equipos")
        print("   - Todos los clientes")
        print("   - Todos los registros de horas")
        print("   - Todas las fotos adjuntas")
        
        respuesta = input("\n¿Estás ABSOLUTAMENTE seguro? (escribe 'RESET' para confirmar): ")
        
        if respuesta.upper() != 'RESET':
            print("❌ Operación cancelada")
            return
        
        print("\n🔄 Iniciando reset completo...")
        
        try:
            # 1. Eliminar archivos de fotos
            print("🗑️  Eliminando archivos de fotos...")
            if os.path.exists('static/uploads'):
                shutil.rmtree('static/uploads')
                os.makedirs('static/uploads', exist_ok=True)
                print("✅ Directorio de fotos limpiado")
            
            # 2. Eliminar archivos QR
            print("🗑️  Eliminando códigos QR...")
            if os.path.exists('static/qr_codes'):
                shutil.rmtree('static/qr_codes')
                os.makedirs('static/qr_codes', exist_ok=True)
                print("✅ Directorio de QR limpiado")
            
            # 3. Eliminar registros de horas
            print("🗑️  Eliminando registros de horas...")
            RegistroHoras.query.delete()
            print("✅ Registros de horas eliminados")
            
            # 4. Eliminar equipos
            print("🗑️  Eliminando equipos...")
            Equipo.query.delete()
            print("✅ Equipos eliminados")
            
            # 5. Eliminar clientes
            print("🗑️  Eliminando clientes...")
            Cliente.query.delete()
            print("✅ Clientes eliminados")
            
            # 6. Eliminar usuarios (excepto admin)
            print("🗑️  Eliminando usuarios...")
            User.query.filter(User.perfil_usuario != 'admin').delete()
            print("✅ Usuarios eliminados (excepto admin)")
            
            # 7. Recrear datos maestros
            print("🔄 Recreando datos maestros...")
            crear_datos_maestros()
            
            # 8. Confirmar cambios
            db.session.commit()
            print("✅ Cambios confirmados en la base de datos")
            
            print("\n🎉 RESET COMPLETO EXITOSO!")
            print("   - Base de datos limpia")
            print("   - Solo administrador y datos maestros")
            print("   - Sistema listo para usar")
            
        except Exception as e:
            db.session.rollback()
            print(f"❌ Error durante el reset: {e}")
            print("🔄 Base de datos restaurada al estado anterior")

def crear_datos_maestros():
    """Recrear datos maestros básicos"""
    # Tipos de equipo
    tipos_equipo = [
        {'descripcion': 'Grúa Torre', 'estado': 'activo'},
        {'descripcion': 'Grúa Móvil', 'estado': 'activo'},
        {'descripcion': 'Montacargas', 'estado': 'activo'}
    ]
    
    for tipo_data in tipos_equipo:
        tipo = TipoEquipo(**tipo_data)
        db.session.add(tipo)
    
    # Marcas
    marcas = [
        {'descripcion': 'Liebherr', 'estado': 'activo'},
        {'descripcion': 'Caterpillar', 'estado': 'activo'},
        {'descripcion': 'Manitowoc', 'estado': 'activo'}
    ]
    
    for marca_data in marcas:
        marca = Marca(**marca_data)
        db.session.add(marca)
    
    # Estados de equipo
    estados_equipo = [
        {'descripcion': 'Operativo', 'estado': 'activo'},
        {'descripcion': 'Averiado', 'estado': 'activo'},
        {'descripcion': 'Mantenimiento', 'estado': 'activo'}
    ]
    
    for estado_data in estados_equipo:
        estado = EstadoEquipo(**estado_data)
        db.session.add(estado)
    
    # Cargos
    cargos = [
        {'descripcion': 'Operador', 'estado': 'activo'},
        {'descripcion': 'Supervisor', 'estado': 'activo'},
        {'descripcion': 'Mecánico', 'estado': 'activo'},
        {'descripcion': 'Ayudante', 'estado': 'activo'}
    ]
    
    for cargo_data in cargos:
        cargo = Cargo(**cargo_data)
        db.session.add(cargo)
    
    print("✅ Datos maestros recreados")

if __name__ == "__main__":
    reset_completo()
