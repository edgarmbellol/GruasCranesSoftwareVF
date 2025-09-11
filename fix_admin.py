#!/usr/bin/env python3
import os
import sys
sys.path.insert(0, '/home/mauricio/apps/flask_app')
from app import app, db
from models import User

with app.app_context():
    # Buscar usuario admin por email
    admin = User.query.filter_by(email='admin@gruascranes.com').first()
    if admin:
        print(f"Usuario encontrado: {admin.documento}")
        admin.documento = 'admin'
        db.session.commit()
        print("Documento cambiado a 'admin'")
    else:
        print("Usuario no encontrado")

