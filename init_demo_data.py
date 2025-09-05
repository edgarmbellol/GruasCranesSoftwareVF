#!/usr/bin/env python3
"""
Script para inicializar datos de demostración
Ejecutar después de clonar el repositorio
"""

from app import app, db
from models import User, Equipo, TipoEquipo, Marca, EstadoEquipo, Cargo, Cliente
from werkzeug.security import generate_password_hash
from datetime import datetime, date

def init_demo_data():
    with app.app_context():
        print("🚀 Inicializando datos de demostración...")
        
        # Verificar si ya existen datos
        if User.query.count() > 1:  # Más que el admin por defecto
            print("⚠️  Ya existen datos en la base de datos")
            return
        
        # Crear empleados de prueba
        empleados_demo = [
            {
                'tipo_documento': 'CC',
                'numero_documento': '12345678',
                'nombre': 'Juan Pérez',
                'email': 'juan.perez@empresa.com',
                'telefono': '3001234567',
                'contrasena': '123456',
                'perfil_usuario': 'empleado'
            },
            {
                'tipo_documento': 'CC',
                'numero_documento': '87654321',
                'nombre': 'María García',
                'email': 'maria.garcia@empresa.com',
                'telefono': '3007654321',
                'contrasena': '123456',
                'perfil_usuario': 'empleado'
            },
            {
                'tipo_documento': 'CC',
                'numero_documento': '11223344',
                'nombre': 'Carlos López',
                'email': 'carlos.lopez@empresa.com',
                'telefono': '3001122334',
                'contrasena': '123456',
                'perfil_usuario': 'empleado'
            }
        ]
        
        for emp_data in empleados_demo:
            empleado = User(
                tipo_documento=emp_data['tipo_documento'],
                numero_documento=emp_data['numero_documento'],
                nombre=emp_data['nombre'],
                email=emp_data['email'],
                telefono=emp_data['telefono'],
                contrasena=generate_password_hash(emp_data['contrasena']),
                perfil_usuario=emp_data['perfil_usuario'],
                estado='activo',
                fecha_creacion=datetime.now()
            )
            db.session.add(empleado)
        
        # Crear clientes de prueba
        clientes_demo = [
            {
                'nombre_cliente': 'Constructora ABC S.A.S',
                'nit': '900123456-1',
                'fecha_creacion': datetime.now(),
                'usuario_crea': 1,
                'estado': 'activo'
            },
            {
                'nombre_cliente': 'Ingeniería XYZ Ltda',
                'nit': '800987654-3',
                'fecha_creacion': datetime.now(),
                'usuario_crea': 1,
                'estado': 'activo'
            },
            {
                'nombre_cliente': 'Proyectos del Norte S.A',
                'nit': '700555666-7',
                'fecha_creacion': datetime.now(),
                'usuario_crea': 1,
                'estado': 'activo'
            }
        ]
        
        for cli_data in clientes_demo:
            cliente = Cliente(
                nombre_cliente=cli_data['nombre_cliente'],
                nit=cli_data['nit'],
                fecha_creacion=cli_data['fecha_creacion'],
                usuario_crea=cli_data['usuario_crea'],
                estado=cli_data['estado']
            )
            db.session.add(cliente)
        
        # Crear equipos adicionales de prueba
        equipos_demo = [
            {
                'placa': 'ABC123',
                'capacidad': 50.0,
                'id_marca': 1,
                'id_tipo_equipo': 1,
                'referencia': 'Modelo 2023',
                'color': 'Amarillo',
                'modelo': 'GC-50',
                'centro_costos': 'Obra Norte',
                'estado': 'activo',
                'id_estado_equipo': 1,
                'usuario_creacion': 1
            },
            {
                'placa': 'XYZ789',
                'capacidad': 25.0,
                'id_marca': 2,
                'id_tipo_equipo': 2,
                'referencia': 'Modelo 2022',
                'color': 'Azul',
                'modelo': 'MC-25',
                'centro_costos': 'Obra Sur',
                'estado': 'activo',
                'id_estado_equipo': 1,
                'usuario_creacion': 1
            }
        ]
        
        for eq_data in equipos_demo:
            equipo = Equipo(
                placa=eq_data['placa'],
                capacidad=eq_data['capacidad'],
                id_marca=eq_data['id_marca'],
                id_tipo_equipo=eq_data['id_tipo_equipo'],
                referencia=eq_data['referencia'],
                color=eq_data['color'],
                modelo=eq_data['modelo'],
                centro_costos=eq_data['centro_costos'],
                estado=eq_data['estado'],
                id_estado_equipo=eq_data['id_estado_equipo'],
                usuario_creacion=eq_data['usuario_creacion'],
                fecha_creacion=datetime.now()
            )
            db.session.add(equipo)
        
        # Guardar todos los cambios
        db.session.commit()
        
        print("✅ Datos de demostración creados exitosamente!")
        print("📋 Empleados creados:")
        print("   - juan.perez@empresa.com (123456)")
        print("   - maria.garcia@empresa.com (123456)")
        print("   - carlos.lopez@empresa.com (123456)")
        print("📋 Clientes creados: 3")
        print("📋 Equipos creados: 2")
        print("\n🚀 El proyecto está listo para usar!")

if __name__ == "__main__":
    init_demo_data()
