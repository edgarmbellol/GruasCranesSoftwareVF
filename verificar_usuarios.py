#!/usr/bin/env python3
"""
Script para verificar usuarios en la base de datos
"""

import os
import sys

# Agregar el directorio del proyecto al path
sys.path.insert(0, '/home/mauricio/apps/flask_app')

from app import app, db
from models import User
from werkzeug.security import check_password_hash

def verificar_usuarios():
    """Verificar usuarios en la base de datos"""
    with app.app_context():
        print("🔍 Verificando usuarios en la base de datos...")
        print("=" * 50)
        
        # Buscar todos los usuarios
        usuarios = User.query.all()
        
        if not usuarios:
            print("❌ No hay usuarios en la base de datos")
            return
        
        print(f"📊 Total de usuarios: {len(usuarios)}")
        print()
        
        for usuario in usuarios:
            print(f"👤 Usuario ID: {usuario.id}")
            print(f"   📄 Documento: {usuario.documento}")
            print(f"   👨‍💼 Nombre: {usuario.nombre}")
            print(f"   📧 Email: {usuario.email}")
            print(f"   🔑 Perfil: {usuario.perfil_usuario}")
            print(f"   📱 Celular: {usuario.celular}")
            print(f"   ✅ Estado: {usuario.estado}")
            print(f"   📅 Fecha creación: {usuario.fecha_creacion}")
            print()
        
        # Probar credenciales
        print("🔐 Probando credenciales...")
        print("-" * 30)
        
        # Buscar usuario por documento
        admin_doc = User.query.filter_by(documento='12345678').first()
        if admin_doc:
            print(f"✅ Usuario encontrado por documento '12345678': {admin_doc.nombre}")
            print(f"   Email: {admin_doc.email}")
            print(f"   Perfil: {admin_doc.perfil_usuario}")
        else:
            print("❌ No se encontró usuario con documento '12345678'")
        
        # Buscar usuario por email
        admin_email = User.query.filter_by(email='admin@gruascranes.com').first()
        if admin_email:
            print(f"✅ Usuario encontrado por email 'admin@gruascranes.com': {admin_email.nombre}")
            print(f"   Documento: {admin_email.documento}")
            print(f"   Perfil: {admin_email.perfil_usuario}")
        else:
            print("❌ No se encontró usuario con email 'admin@gruascranes.com'")
        
        # Buscar usuario por documento 'admin'
        admin_simple = User.query.filter_by(documento='admin').first()
        if admin_simple:
            print(f"✅ Usuario encontrado por documento 'admin': {admin_simple.nombre}")
            print(f"   Email: {admin_simple.email}")
            print(f"   Perfil: {admin_simple.perfil_usuario}")
        else:
            print("❌ No se encontró usuario con documento 'admin'")

def main():
    """Función principal"""
    print("🔍 Verificador de Usuarios - Sistema de Grúas")
    print("=" * 45)
    
    verificar_usuarios()

if __name__ == "__main__":
    main()

