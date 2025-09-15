#!/usr/bin/env python3
"""
Script para restablecer contraseñas de usuarios
Uso: python reset_password.py [documento] [nueva_contraseña]
"""

import sys
from models import User, db
from app import app
from werkzeug.security import generate_password_hash

def reset_password(documento, nueva_contraseña):
    """Restablecer contraseña de un usuario"""
    with app.app_context():
        user = User.query.filter_by(documento=documento).first()
        
        if not user:
            print(f"❌ Usuario con documento {documento} no encontrado")
            return False
        
        # Actualizar contraseña
        user.contrasena_hash = generate_password_hash(nueva_contraseña)
        db.session.commit()
        
        print(f"✅ Contraseña restablecida exitosamente")
        print(f"   Usuario: {user.nombre}")
        print(f"   Documento: {user.documento}")
        print(f"   Email: {user.email}")
        print(f"   Nueva contraseña: {nueva_contraseña}")
        
        return True

def list_users():
    """Listar todos los usuarios"""
    with app.app_context():
        print("=== USUARIOS EN EL SISTEMA ===")
        usuarios = User.query.all()
        
        for user in usuarios:
            print(f"Documento: {user.documento} | Nombre: {user.nombre} | Email: {user.email} | Perfil: {user.perfil_usuario}")

if __name__ == "__main__":
    if len(sys.argv) == 1:
        print("Uso: python reset_password.py [documento] [nueva_contraseña]")
        print("      python reset_password.py --list (para listar usuarios)")
        sys.exit(1)
    
    if sys.argv[1] == "--list":
        list_users()
    elif len(sys.argv) == 3:
        documento = sys.argv[1]
        nueva_contraseña = sys.argv[2]
        reset_password(documento, nueva_contraseña)
    else:
        print("❌ Argumentos incorrectos")
        print("Uso: python reset_password.py [documento] [nueva_contraseña]")
        print("      python reset_password.py --list")
