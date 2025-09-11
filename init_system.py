#!/usr/bin/env python3
"""
Script de inicialización completa del sistema
Inicializa la base de datos con datos maestros específicos
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

def init_cargos():
    """Inicializa los cargos específicos requeridos"""
    cargos_requeridos = [
        {"codigo": "01", "descripcion": "Operador"},
        {"codigo": "02", "descripcion": "Aparejador"},
        {"codigo": "03", "descripcion": "Supervisor"},
        {"codigo": "04", "descripcion": "HSEQ"},
        {"codigo": "05", "descripcion": "Mantenimiento"}
    ]
    
    with app.app_context():
        try:
            # Limpiar cargos existentes
            Cargo.query.delete()
            
            # Crear cargos requeridos
            for cargo_data in cargos_requeridos:
                cargo = Cargo(
                    descripcionCargo=cargo_data["descripcion"],
                    Estado='activo'
                )
                db.session.add(cargo)
            
            db.session.commit()
            print(f"✅ {len(cargos_requeridos)} cargos inicializados")
            return True
            
        except Exception as e:
            print(f"❌ Error inicializando cargos: {str(e)}")
            db.session.rollback()
            return False

def init_tipos_equipos():
    """Inicializa tipos de equipos básicos"""
    tipos_requeridos = [
        "Grúa Torre",
        "Grúa Móvil", 
        "Montacargas",
        "Plataforma Elevadora",
        "Grúa Telescópica"
    ]
    
    with app.app_context():
        try:
            # Solo crear si no existen
            if TipoEquipo.query.count() == 0:
                for tipo_desc in tipos_requeridos:
                    tipo = TipoEquipo(
                        descripcion=tipo_desc,
                        estado='activo'
                    )
                    db.session.add(tipo)
                
                db.session.commit()
                print(f"✅ {len(tipos_requeridos)} tipos de equipos inicializados")
            else:
                print("ℹ️  Tipos de equipos ya existen")
            return True
            
        except Exception as e:
            print(f"❌ Error inicializando tipos de equipos: {str(e)}")
            db.session.rollback()
            return False

def init_marcas():
    """Inicializa marcas básicas"""
    marcas_requeridas = [
        "Caterpillar",
        "Liebherr", 
        "Terex",
        "Manitowoc",
        "Grove",
        "Kato",
        "Kobelco"
    ]
    
    with app.app_context():
        try:
            # Solo crear si no existen
            if Marca.query.count() == 0:
                for marca_desc in marcas_requeridas:
                    marca = Marca(
                        DescripcionMarca=marca_desc,
                        Estado='activo'
                    )
                    db.session.add(marca)
                
                db.session.commit()
                print(f"✅ {len(marcas_requeridas)} marcas inicializadas")
            else:
                print("ℹ️  Marcas ya existen")
            return True
            
        except Exception as e:
            print(f"❌ Error inicializando marcas: {str(e)}")
            db.session.rollback()
            return False

def init_estados_equipos():
    """Inicializa estados de equipos básicos"""
    estados_requeridos = [
        "Operativo",
        "Mantenimiento",
        "Averiado", 
        "Fuera de Servicio",
        "En Reparación"
    ]
    
    with app.app_context():
        try:
            # Solo crear si no existen
            if EstadoEquipo.query.count() == 0:
                for estado_desc in estados_requeridos:
                    estado = EstadoEquipo(
                        Descripcion=estado_desc,
                        Estado='activo'
                    )
                    db.session.add(estado)
                
                db.session.commit()
                print(f"✅ {len(estados_requeridos)} estados de equipos inicializados")
            else:
                print("ℹ️  Estados de equipos ya existen")
            return True
            
        except Exception as e:
            print(f"❌ Error inicializando estados de equipos: {str(e)}")
            db.session.rollback()
            return False

def show_summary():
    """Muestra resumen de la inicialización"""
    with app.app_context():
        print("\n📊 Resumen de inicialización:")
        print("=" * 40)
        print(f"Cargos: {Cargo.query.count()}")
        print(f"Tipos de equipos: {TipoEquipo.query.count()}")
        print(f"Marcas: {Marca.query.count()}")
        print(f"Estados de equipos: {EstadoEquipo.query.count()}")
        print(f"Usuarios: {User.query.count()}")
        print("=" * 40)

def main():
    """Función principal"""
    print("🔧 Inicializador del Sistema - Sistema de Grúas")
    print("=" * 50)
    
    # Verificar que estamos en el directorio correcto
    if not os.path.exists('/home/mauricio/apps/flask_app/app.py'):
        print("❌ Error: No se encontró la aplicación Flask")
        sys.exit(1)
    
    success = True
    
    # Inicializar cada componente
    print("🔄 Inicializando componentes del sistema...")
    
    if not init_cargos():
        success = False
    
    if not init_tipos_equipos():
        success = False
    
    if not init_marcas():
        success = False
    
    if not init_estados_equipos():
        success = False
    
    if success:
        print("\n🎉 ¡Inicialización completada exitosamente!")
        show_summary()
        print("\n✅ El sistema está listo para usar")
    else:
        print("\n❌ Error durante la inicialización")

if __name__ == "__main__":
    main()

