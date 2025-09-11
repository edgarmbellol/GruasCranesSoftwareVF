#!/usr/bin/env python3
"""
Script para corregir el usuario administrador
"""

import os
import sys

# Agregar el directorio del proyecto al path
sys.path.insert(0, '/home/mauricio/apps/flask_app')

from app import app, db
from models import User

def corregir_usuario_admin():
    """Corregir el usuario administrador"""
    with app.app_context():
        print("🔧 Corrigiendo usuario administrador...")
        print("=" * 40)
        
        # Buscar el usuario admin existente
        admin_user = User.query.filter_by(email='admin@gruascranes.com').first()
        
        if admin_user:
            print(f"✅ Usuario encontrado: {admin_user.nombre}")
            print(f"   Documento actual: {admin_user.documento}")
            print(f"   Email: {admin_user.email}")
            print(f"   Perfil: {admin_user.perfil_usuario}")
            
            # Cambiar el documento a 'admin' para facilitar el login
            admin_user.documento = 'admin'
            db.session.commit()
            
            print("✅ Documento cambiado a 'admin'")
            print("✅ Usuario administrador corregido")
            print()
            print("🔑 Credenciales de acceso:")
            print("   Usuario: admin")
            print("   Contraseña: admin123")
            
        else:
            print("❌ No se encontró el usuario administrador")
            print("   Creando nuevo usuario administrador...")
            
            # Crear nuevo usuario admin
            admin_user = User(
                tipo_documento='CC',
                documento='admin',
                nombre='Administrador',
                email='admin@gruascranes.com',
                celular='3001234567',
                contrasena='admin123',
                perfil_usuario='administrador'
            )
            db.session.add(admin_user)
            db.session.commit()
            
            print("✅ Usuario administrador creado")
            print("🔑 Credenciales de acceso:")
            print("   Usuario: admin")
            print("   Contraseña: admin123")

def main():
    """Función principal"""
    print("🔧 Corrector de Usuario Administrador")
    print("=" * 35)
    
    corregir_usuario_admin()

if __name__ == "__main__":
    main()

